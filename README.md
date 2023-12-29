# TerminalSize.jl
TerminalSize is a very small library to read out the current terminal size (characters and pixels).

The library exports only two symbols:
## get_terminal_size
Retrieves the size of the terminal from the tty device.
```julia
get_terminal_size()::WinSize
get_terminal_size(tty::Base.TTY)::WinSize
get_terminal_size(raw_fd::Base.RawFD)::WinSize
get_terminal_size(fd::Integer)::WinSize
```
## WinSize
Structure, which holds the result.
```julia
mutable struct WinSize
    row::UInt16                 # number of rows
    col::UInt16                 # number of columns
    xpixel::UInt16              # number of pixel in x-direction
    ypixel::UInt16              # number of pixel in x-direction
    cells::NTuple{2, UInt16}    # tuple with (col, row)
    pixels::NTuple{2, UInt16}   # tuple with (xpixel, ypixel)
end
```


