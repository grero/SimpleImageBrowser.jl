using SimpleImageBrowser
using Test

@testset "Basic" begin
    tdir = tempdir()
    cd(tdir) do
        #grab some test images
        download("https://upload.wikimedia.org/wikipedia/commons/thumb/c/cf/Pears.jpg/256px-Pears.jpg", "pear.jpg")
        download("https://upload.wikimedia.org/wikipedia/commons/thumb/f/f4/Honeycrisp.jpg/512px-Honeycrisp.jpg", "apple.jpg")
        img_files = ["apple.jpg","pear.jpg"]
        SimpleImageBrowser.generate_webpage(img_files)
        @test isfile("app/images/apple.jpg")
        @test isfile("app/images/pear.jpg")
        @test isfile("app/index.html")
        txt = readchomp(open("app/index.html"))
        @test txt == "<html><head><title>Simple Image Browoser</title></head>\n<body>\n<img src=images/apple.jpg width=256.0 height=256.0 border=1px>\n<img src=images/pear.jpg width=128.0 height=195.0 border=1px>\n</body>\n</html>"
        #cleanup
        rm("app", recursive=true, force=true)
        #force image size to be the same
        SimpleImageBrowser.generate_webpage(img_files, (512,512))
        txt = readchomp(open("app/index.html"))
        @test txt == "<html><head><title>Simple Image Browoser</title></head>\n<body>\n<img src=images/apple.jpg width=256.0 height=256.0 border=1px>\n<img src=images/pear.jpg width=256.0 height=256.0 border=1px>\n</body>\n</html>"
        #cleanup
        rm("app", recursive=true, force=true)
        qq = Dict("one" => img_files, "two" => img_files)
        kqq = collect(keys(qq))
        SimpleImageBrowser.generate_webpage(qq, (512, 512))
        @test isfile("app/index.html")
        txt = readchomp(open("app/index.html"))
        @test txt == "<html><head></head>\n<body>\n<a href=\"$(kqq[1])/index.html\">$(kqq[1])</a>\n<a href=\"$(kqq[2])/index.html\">$(kqq[2])</a>\n</body>\n</html>" 
        @test isfile("app/one/index.html")
        @test isfile("app/one/images/apple.jpg")
        @test isfile("app/one/images/pear.jpg")
        @test isfile("app/two/index.html")
        @test isfile("app/two/images/apple.jpg")
        @test isfile("app/two/images/pear.jpg")
        #cleanup
        rm("app", recursive=true, force=true)
        rm.(["apple.jpg","pear.jpg"])
    end
end
