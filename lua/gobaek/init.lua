local M = {}

-- Create a directory and file for the problem
function M.create_problem(problem_number)
	if not problem_number or problem_number == "" then
		print("문제 번호를 입력하세요: :Gobaek [문제번호]")
		return
	end

	-- Set up paths
	local base_dir = "baekjoon"
	local problem_dir = base_dir .. "/problem" .. problem_number
	local main_file = problem_dir .. "/main.go"

	-- Create directories if they don't exist
	vim.fn.mkdir(problem_dir, "p")

	-- Check if main.go already exists
	if vim.fn.filereadable(main_file) == 1 then
		print("main.go already exists for problem " .. problem_number)
		return
	end

	-- Write a basic Go template to main.go
	local template = [[
package main

import "fmt"

func main() {
    fmt.Println("Hello, Problem ]] .. problem_number .. [[!")
}
]]
	local file = io.open(main_file, "w")
	file:write(template)
	file:close()

	print("Created: " .. main_file)

	-- Open the newly created file in the current buffer
	vim.cmd("edit " .. main_file)
end

-- Define the :Gobaek command
function M.setup()
	vim.api.nvim_create_user_command("Gobaek", function(opts)
		M.create_problem(opts.args)
	end, { nargs = 1 })
end

return M
