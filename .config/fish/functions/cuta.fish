function cuta --description 'Trim audio from the end and add fade in/out'
    # Usage:
    #   cuta <file> -d <duration> [--fi N] [--fo N]
    #
    # Examples:
    #   cuta song.mp3 -d 30                 # trim to 30s, fo=3 by default
    #   cuta song.mp3 -d 30 --fi 2 --fo 5   # fi=2s, fo=5s
    #   cuta song.mp3 -d 30 --fo 0          # no fade out

    if test (count $argv) -lt 1
        echo "Usage: cuta <file> -d <duration> [--fi N] [--fo N]" >&2
        echo "  <file>       — input audio file" >&2
        echo "  -d N         — final length in seconds (trim from the end), required" >&2
        echo "  --fi N       — fade in duration (default 0)" >&2
        echo "  --fo N       — fade out duration (default 3)" >&2
        return 1
    end

    set -l input $argv[1]
    set -l d ""
    set -l fi 0
    set -l fo 3

    set -l i 2
    while test $i -le (count $argv)
        switch $argv[$i]
            case -d
                set i (math $i + 1)
                if test $i -gt (count $argv)
                    echo "Error: -d requires a value" >&2
                    return 1
                end
                set d $argv[$i]
            case --fi
                set i (math $i + 1)
                if test $i -gt (count $argv)
                    echo "Error: --fi requires a value" >&2
                    return 1
                end
                set fi $argv[$i]
            case --fo
                set i (math $i + 1)
                if test $i -gt (count $argv)
                    echo "Error: --fo requires a value" >&2
                    return 1
                end
                set fo $argv[$i]
            case '-*'
                echo "Unknown argument: $argv[$i]" >&2
                return 1
            case '*'
                echo "Extra argument: $argv[$i]" >&2
                return 1
        end
        set i (math $i + 1)
    end

    if test -z "$d"
        echo "Error: duration not specified (-d N)" >&2
        return 1
    end

    if not test -f "$input"
        echo "File not found: $input" >&2
        return 1
    end

    set -l filters

    if test $fi != 0
        set -a filters "afade=t=in:st=0:d=$fi"
    end

    if test $fo != 0
        set -l fo_start (math "$d - $fo")
        if test $fo_start -lt 0
            set fo_start 0
        end
        set -a filters "afade=t=out:st=$fo_start:d=$fo"
    end

    set -l base (string replace -r '\.[^.]*$' '' -- $input)
    set -l output "$base (trim).mp3"

    set -l filter_arg "anull"
    if test (count $filters) -gt 0
        set filter_arg (string join ',' $filters)
    end

    echo "→ $input  ⇒  $output"
    echo "  duration: $d s | fade in: $fi s | fade out: $fo s"
    echo "  filter: $filter_arg"

    ffmpeg -hide_banner -loglevel error -y -i "$input" -t $d -af "$filter_arg" "$output"

    if test $status -eq 0
        echo "✓ Done: $output"
    else
        echo "✗ ffmpeg error" >&2
        return 1
    end
end
