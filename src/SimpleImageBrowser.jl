module SimpleImageBrowser
using Images
using Glob
using ProgressMeter
using FileIO

function generate_html(imgfiles::Vector{String})
    imgsize = Vector{Tuple{Int64, Int64}}(undef, length(imgfiles))
    for (ii,ff) in enumerate(imgfiles)
        img = load(ff)
        imgsize[ii] = size(img)
    end
    generate_html(imgfiles, imgsize)
end

function generate_html(imgfiles::Vector{String}, imgsize::Tuple{Int64, Int64})
    generate_html(imgfiles, fill(imgsize, length(imgfiles)))
end

function generate_html(imgfiles::Vector{String}, imgsize::Vector{Tuple{Int64, Int64}})
    output = String[]
    push!(output,"<html><head><title>Simple Image Browoser</title></head>")
    push!(output, "<body>")
    pp = Progress(length(imgfiles), "Analyzing images...", 1)
    for (ii,ff) in enumerate(imgfiles)
        #this is just to get the size
        _img_size = 0.5.*(imgsize[ii])
        push!(output, "<img src=$ff width=$(_img_size[2]) height=$(_img_size[1]) border=1px>")
        update!(pp, ii)
    end
    push!(output, "</body>")
    push!(output, "</html>")
    return join(output, '\n')
end

function generate_webpage(outfile::String, imgfiles::Vector{String})
    output = generate_html(imgfiles)
    open(outfile, "w") do ff
        write(ff, output)
    end
end

function generate_webpage(imgfiles::Vector{String},args...)
    mkpath("app/images")
    new_imgfiles = String[]
    for ff in imgfiles
        ffn = basename(ff)
        cp(ff, joinpath("app","images", ffn))
        push!(new_imgfiles, joinpath("images", ffn))
    end
    cd("app") do
        output = generate_html(new_imgfiles,args...)
        open("index.html","w") do ff
            write(ff, output) 
        end
    end
end

end # module
