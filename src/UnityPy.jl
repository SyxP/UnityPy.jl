module UnityPy

    using PythonCall

    const unityPy = Ref{Py}()

    function __init__()
        global unityPy[] = PythonCall.pyimport("UnityPy")
        (unityPy[]).config.FALLBACK_UNITY_VERSION = "2021.3.0f1"
    end

    export LoadTextBundle

    function LoadTextBundle(filePath, destPath)
        pyBundle = (unityPy[]).load(filePath)

        for obj in pyBundle.objects
            objTypeName = pyconvert(String, obj.type.name)
            objTypeName == "TextAsset" || continue

            data = obj.read()
            dataName = pyconvert(String, obj.container)
            destLocation = joinpath(destPath, dataName)
            mkpath(dirname(destLocation))
            
            open(destLocation, "w") do io
                contents = pyconvert(String, data.m_Script)
                print(io, contents)
            end
        end
    end
end
