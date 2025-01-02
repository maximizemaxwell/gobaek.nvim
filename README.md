# GoBaek.nvim

아무 생각 없이 만든 플러그인
별건없고 백준 디렉토리 안에 문항번호 디렉토리와 main.go를 넣어줍니다.

## Installation

### Using Lazy.nvim
```lua
{
  "maximizemaxwell/gobaek.nvim",
    lazy = true,
    cmd = "Gobaek",
    config = function()
        require("gobaek").setup()
  end,
}
```
## Usage

```vim
:Gobaek <문제번호>
```

예시
```vim
:Gobaek 123
```

를 치면

```css
baekjoon/
└── problem123/
    └── main.go
```
백준 디렉토리가 없으면 생기고 있으면 문제번호 디렉토리와 main.go가 생깁니다.

별 건 없지만 문제번호를 환영하는 스크립트가 있어요.

```go
package main

import "fmt"

func main() {
    fmt.Println("Hello, Problem 123!")
}
```
