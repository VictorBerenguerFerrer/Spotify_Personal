# YouTube Audio Extractor 
App Flutter + Backend Python para convertir enlaces de YouTube en audio (uso personal).

## Estructura
- `/frontend` → App Flutter (UI + reproductor)
- `/backend` → API Python (FastAPI + yt-dlp)

## Uso
1. Ejecutar el backend:
   ```bash
   uvicorn main:app --reload
