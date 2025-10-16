from fastapi import FastAPI, Query 
from fastapi.responses import FileResponse
import yt_dlp
import os

app = FastAPI()

@app.get("/download_audio")
def download_audio(url:str = Query(...)):
    
    # Creamos una variable para la carpeta donde se van a guardar las canciones(si no existe la carpeta, la creará) 
    output_path = "output"
    os.makedirs(output_path, exist_ok=True)
    filename = os.path.join(output_path,"%(title)s.%(ext)s")

    # Definimos los parámetros de las canciones para que las descargue con el formato correcto
    ydl_opts = {
        "format" : "bestaudio/best",
        "outtmpl" : filename,
        "postpocessors" : [{
                "key" : "FFmpegExtractAudio",
                "preferredecodec" : "mp3",
                "preferredquality" : "192",
        }],
    }

    # Descargamos el audio y lo devolvemos en el return
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        info = ydl.extract_info(url,download=True)
        file_name = ydl.prepare_filename(info).replace(".webm",".mp3")

    return FileResponse(file_name, filename=os.path.basename(file_name))