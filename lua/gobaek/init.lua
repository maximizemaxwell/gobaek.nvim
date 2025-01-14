local M = {}

-- 공통 템플릿 생성 함수
local function create_template(problem_number, message)
	return [[
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
  fmt.Fprintln(writer, "Hello, ]] .. message .. [[!")
}
]]
end

-- 문제 디렉토리 및 main.go 생성
function M.create_problem(problem_number)
	if not problem_number or problem_number == "" then
		print("문제 번호를 입력하세요: :Gobaek [문제번호]")
		return
	end

	local base_dir = "baekjoon"
	local problem_dir = base_dir .. "/problem" .. problem_number
	local main_file = problem_dir .. "/main.go"

	vim.fn.mkdir(problem_dir, "p")

	if vim.fn.filereadable(main_file) == 1 then
		print("main.go already exists for problem " .. problem_number)
		return
	end

	local template = create_template(problem_number, "Problem " .. problem_number)
	local file = io.open(main_file, "w")
	file:write(template)
	file:close()

	print("Created: " .. main_file)
	vim.cmd("edit " .. main_file)
end

-- 문제 초기화 (Reset)
function M.reset_problem(problem_number)
	if not problem_number or problem_number == "" then
		print("문제 번호를 입력하세요: :Gobaek Reset [문제번호]")
		return
	end

	local base_dir = "baekjoon"
	local problem_dir = base_dir .. "/problem" .. problem_number
	local main_file = problem_dir .. "/main.go"

	vim.fn.mkdir(problem_dir, "p")

	if vim.fn.filereadable(main_file) == 1 then
		os.remove(main_file)
		print("Removed existing main.go for problem " .. problem_number)
	end

	local template = create_template(problem_number, "Reset Problem " .. problem_number)
	local file = io.open(main_file, "w")
	file:write(template)
	file:close()

	print("Reset and created: " .. main_file)
	vim.cmd("edit " .. main_file)
end

-- 디렉토리 이동 (GOTO)
function M.goto_problem(problem_number)
	if not problem_number or problem_number == "" then
		print("문제 번호를 입력하세요: :Gobaek GOTO [문제번호]")
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

	local cmd = string.format("tmux split-window -p 25 -c '%s' 'zsh -i'", problem_dir)
	os.execute(cmd)
end

-- 도움말 출력
function M.help()
	print("Usage:")
	print("  :Gobaek [문제번호]        -- 문제 디렉토리 및 main.go 생성")
	print("  :Gobaek Reset [문제번호] -- 이미 있는 main.go를 초기 템플릿으로 재생성")
	print("  :Gobaek GOTO [문제번호]  -- tmux 하단 25%창에서 go run main.go 실행")
	print("  :Gobaek Help             -- 도움말 출력")
end

-- Neovim UserCommand 정의
function M.setup()
	vim.api.nvim_create_user_command("Gobaek", function(opts)
		local args = opts.fargs
		local subcmd = args[1]
		local problem_number = args[2]

		if #args == 1 and tonumber(args[1]) ~= nil then
			M.create_problem(args[1])
			return
		end

		if subcmd == "Reset" then
			M.reset_problem(problem_number)
		elseif subcmd == "GOTO" then
			M.goto_problem(problem_number)
		elseif subcmd == "Help" then
			M.help()
		else
			M.help()
		end
	end, { nargs = "+" })
end

return M
