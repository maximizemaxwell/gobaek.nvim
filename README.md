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
### 문제 파일 생성

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

별 건 없지만 문제번호를 환영하는 기본 스크립트가 있어요.

```go
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
  fmt.Fprintln(writer, "Hello, Problem [문제번호]!")
}
```

### 문제 초기화

```vim
:Gobaek Reset 123
```
을 하면 해당 문제파일이 기본스크립트로 돌아갑니다.


### 해당 경로로 터미널을 분할해서 만들어줍니다.

```vim
:Gobaek Goto 123
```
tmux가 커져있다면 화면을 분할하고 해당 파일을 실행해요.
