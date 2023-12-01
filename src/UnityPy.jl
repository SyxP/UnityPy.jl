module UnityPy

    using PythonCall

    const unityPy = PythonCall.pynew()

    function __init__()
        PythonCall.pycopy!(unityPy, pyimport("UnityPy"))
    end

    export LoadTextBundle

    function LoadTextBundle(filePath, destPath)
        pyBundle = unityPy.load(filePath)

        for obj in pyBundle.objects
            objTypeName = pyconvert(String, obj.type.name)
            objTypeName == "TextAsset" || continue

            data = obj.read()
            dataName = pyconvert(String, data.container)
            destLocation = joinpath(destPath, dataName)
            mkpath(dirname(destLocation))
            
            open(destLocation, "w") do io
                contents = pyconvert(String, obj.read().text)
                print(io, contents)
            end
        end
    end
end
