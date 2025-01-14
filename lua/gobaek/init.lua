local M = {}

----------------------------------------------------------------
-- 1. 문제 디렉토리(baekjoon/problem1234 등)와 main.go를 만드는 함수
----------------------------------------------------------------
function M.create_problem(problem_number)
	if not problem_number or problem_number == "" then
		print("문제 번호를 입력하세요: :Gobaek [문제번호]")
		return
	end

	-- Set up paths
	local base_dir = "baekjoon"
	local problem_dir = base_dir .. "/problem" .. problem_number
	local main_file = problem_dir .. "/main.go"

	-- 디렉토리가 없으면 만들기
	vim.fn.mkdir(problem_dir, "p")

	-- 파일이 이미 있으면 종료
	if vim.fn.filereadable(main_file) == 1 then
		print("main.go already exists for problem " .. problem_number)
		return
	end

	-- 기본 Go 템플릿
	local template = [[
package main

import (
  "fmt"
  "bufio"
  "os"
)

func main() {
  var reader *bufio.Reader = bufio.NewReader(os.Stdin)
  var writer *bufio.Writer = bufio.NewWriter(os.Stdout)
  defer writer.Flush()

  var n int

  fmt.Fscanln(reader, &n)

  fmt.Fprintln(writer, "Hello, Problem ]] .. problem_number .. [[!")
}
]]

	local file = io.open(main_file, "w")
	file:write(template)
	file:close()

	print("Created: " .. main_file)

	-- 새로 만든 main.go 열기
	vim.cmd("edit " .. main_file)
end

----------------------------------------------------------------
-- 2. Reset: 이미 존재해도 템플릿 상태로 '재생성'해주는 함수
----------------------------------------------------------------
function M.reset_problem(problem_number)
	if not problem_number or problem_number == "" then
		print("문제 번호를 입력하세요: :Gobaek Reset [문제번호]")
		return
	end

	local base_dir = "baekjoon"
	local problem_dir = base_dir .. "/problem" .. problem_number
	local main_file = problem_dir .. "/main.go"

	-- 만약 해당 디렉토리가 없다면 새로 생성
	vim.fn.mkdir(problem_dir, "p")

	-- 기존 main.go를 지우고(존재하면), 새 템플릿으로 생성
	if vim.fn.filereadable(main_file) == 1 then
		os.remove(main_file)
		print("Removed existing main.go for problem " .. problem_number)
	end

	local template = [[
package main

import (
  "fmt"
  "bufio"
  "os"
)

func main() {
  var reader *bufio.Reader = bufio.NewReader(os.Stdin)
  var writer *bufio.Writer = bufio.NewWriter(os.Stdout)
  defer writer.Flush()
  fmt.Fprintln(writer, "Hello, Reset Problem ]] .. problem_number .. [[!")
}
]]

	local file = io.open(main_file, "w")
	file:write(template)
	file:close()

	print("Reset and created: " .. main_file)

	-- 새로 만든 main.go 열기
	vim.cmd("edit " .. main_file)
end

----------------------------------------------------------------
-- 3. Run: tmux로 하단에 25% 차지하는 패널을 만들어 실행
----------------------------------------------------------------
function M.run_problem(problem_number)
	if not problem_number or problem_number == "" then
		print("문제 번호를 입력하세요: :Gobaek Run [문제번호]")
		return
	end

	local base_dir = "baekjoon"
	local problem_dir = base_dir .. "/problem" .. problem_number
	local main_file = problem_dir .. "/main.go"

	if vim.fn.filereadable(main_file) == 0 then
		print("No main.go found for problem " .. problem_number .. ".")
		print(
			"먼저 :Gobaek " .. problem_number .. " 혹은 :Gobaek Reset " .. problem_number .. " 로 생성하세요."
		)
		return
	end

	-- tmux split-window -p 25 로 세로 분할을 25%로 설정
	-- -c 옵션으로 실행 디렉토리 지정

	local cmd = string.format(
		[[
tmux split-window -p 25 -c '%s' "zsh -ic \"
/usr/bin/time -f '%%e %%M' -o /tmp/time_output.txt go run main.go > /tmp/program_output.txt 2>&1;

# time 출력값 예: '1.57 24568' (초, 최대 메모리KB)
TIME_MEM=\$(cat /tmp/time_output.txt);
SECONDS=\$(echo \$TIME_MEM | awk '{print \$1}');  # 1.57
MEMKB=\$(echo \$TIME_MEM | awk '{print \$2}');    # 24568

# 반올림: 1.57 -> 2초, 24568KB -> 약24MB
TIMESEC=\$(awk -v s=\$SECONDS 'BEGIN{printf(\"%%.0f\", s+0.5)}');
MEMMB=\$(awk -v m=\$MEMKB 'BEGIN{printf(\"%%.0f\", m/1024+0.5)}');

# 원하는 포맷으로 출력
echo \"=============================================\";
echo \"\$TIMESEC 초 \$MEMMB MB\";
echo;
echo \"[실행결과]\";
cat /tmp/program_output.txt;

# 셸이 바로 종료되지 않도록 exec zsh
exec zsh
\""
]],
		problem_dir
	)

	os.execute(cmd)
end

----------------------------------------------------------------
-- 4. Neovim UserCommand 정의
--    :Gobaek [문제번호], :Gobaek Reset [문제번호], :Gobaek Run [문제번호]
----------------------------------------------------------------
function M.setup()
	vim.api.nvim_create_user_command("Gobaek", function(opts)
		local args = opts.fargs
		local subcmd = args[1] -- "Reset", "Run" 등의 서브커맨드
		local problem_number = args[2] -- 문제 번호

		-- Gobaek만 호출된 경우 (= :Gobaek 1000 같은 형태)는 create_problem 사용
		if #args == 1 and tonumber(args[1]) ~= nil then
			M.create_problem(args[1])
			return
		end

		if subcmd == "Reset" then
			M.reset_problem(problem_number)
		elseif subcmd == "Run" then
			M.run_problem(problem_number)
		else
			-- 사용법 안내
			print("Usage:")
			print("  :Gobaek [문제번호]        -- 문제 디렉토리 및 main.go 생성")
			print("  :Gobaek Reset [문제번호] -- 이미 있는 main.go를 초기 템플릿으로 재생성")
			print("  :Gobaek Run [문제번호]   -- tmux 하단 25%창에서 go run main.go 실행")
		end
	end, { nargs = "+" })
end

return M
