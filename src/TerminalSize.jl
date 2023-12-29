module TerminalSize

export TerminalSize, get_terminal_size

mutable struct WinSize
    row::UInt16
    col::UInt16
    xpixel::UInt16
    ypixel::UInt16
    cells::NTuple{2, UInt16}
    pixels::NTuple{2, UInt16}
    WinSize() = new(0, 0, 0, 0, (0, 0), (0, 0))
end

terminal_size::WinSize = WinSize()
TIOCGWINSZ::Cint = 0x5413

get_terminal_size()::WinSize = get_terminal_size(Base.stdout)
get_terminal_size(tty::Base.TTY)::WinSize = get_terminal_size(Base._fd(tty))
get_terminal_size(raw_fd::Base.RawFD)::WinSize = get_terminal_size(Base.bitcast(Cint, raw_fd))

function get_terminal_size(fd::Integer)::WinSize
    ret = @ccall ioctl(fd::Cint, TIOCGWINSZ::Cint, terminal_size::Ref{WinSize})::Cint
    if ret == -1
        throw(Base.SystemError("in 'get_terminal_size': ioctl(fd = $(fd), request = TIOCGWINSZ, dataptr = $(repr(UInt(pointer_from_objref(terminal_size)))))"))
    end
    terminal_size.cells = (terminal_size.col, terminal_size.row)
    terminal_size.pixels = (terminal_size.xpixel, terminal_size.ypixel)
    return terminal_size
end

Base.show(io::IO, x::WinSize) = print(io, "WinSize(row = $(x.row), col = $(x.col), xpixel = $(x.xpixel), ypixel = $(x.ypixel))")

# precompile
precompile(get_terminal_size, ())
precompile(get_terminal_size, (Base.TTY,))
precompile(get_terminal_size, (Base.RawFD,))
precompile(get_terminal_size, (Cint,))

end # module TerminalSize
