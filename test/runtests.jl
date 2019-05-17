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
        rm.(["apple.jpg","pear.jpg"])
    end
end
