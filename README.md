# SaotomeMangaSDP26

Proyecto final de la formación Swift Developer Program 25/26 de Apple Coding Academy.

## 🎯 Descripción

**SaotomeMangaSDP26** permite a los usuarios explorar un extenso catálogo de mangas, organizarlos por diferentes categorías y gestionar su colección personal indicando qué tomos han adquirido y por cuál van leyendo.

## ✨ Características Principales

### Exploración y Búsqueda
- Consulta de más de 64.000 mangas de la base de datos
- Búsqueda por título (coincidencia exacta o contenido)
- Filtrado completo por:
  - **Géneros**: Action, Adventure, Romance, Comedy, Sci-Fi, etc.
  - **Demografías**: Shounen, Shoujo, Seinen, Josei, Kids
  - **Temáticas**: Martial Arts, Super Power, School, Mecha, Vampires, Music, etc.
  - **Autores**
- Visualización de los mejores mangas por puntuación

### Información Detallada
- Portadas e imágenes de cada manga
- Sinopsis y contexto
- Autores y su rol (Story, Art, o Story & Art)
- Fecha de inicio y finalización
- Número total de volúmenes y capítulos
- Puntuación y estado (en curso, finalizado, etc.)

### Gestión de Colección Personal
- Añadir mangas a tu colección
- Marcar tomos adquiridos
- Registrar el tomo por el que vas leyendo
- Indicar si posees la colección completa
- Persistencia local de los datos

### Diseño Adaptativo
- **Múltiples vistas**: Listados, detalle y grid
- **Universal**: Diseño optimizado tanto para iPhone como para iPad
- Interfaz intuitiva y funcional

## 🛠️ Tecnologías

- Swift 6 y SwiftUI
- Consumo de API REST
- Persistencia local de datos
- Arquitectura MVVM adaptada a SwiftUI
- Manejo de imágenes remotas (AsyncImage)
- Navegación y gestión de estados

## 📡 API

La aplicación consume la API alojada en:
```
https://mymanga-acacademy-5607149ebe3d.herokuapp.com/
```

### Endpoints principales utilizados:
- `/list/mangas` - Listado paginado de mangas
- `/list/bestMangas` - Mejores mangas por puntuación
- `/list/mangaByGenre/{genre}` - Filtrado por género
- `/list/mangaByDemographic/{demographic}` - Filtrado por demografía
- `/list/mangaByTheme/{theme}` - Filtrado por temática
- `/search/mangasContains/{query}` - Búsqueda por título
- `/search/author/{name}` - Búsqueda de autores

## Requisitos
- iOS 18 / Xcode 16+ (ajusta según tu caso)
- Swift 6+

## Instalación
1. Clona el repositorio.
2. Abre `SaotomeMangaSDP26.xcodeproj` o `.xcworkspace`.
3. Ejecuta en un simulador o dispositivo.

## Capturas
In progress...

## Licencia
MIT
