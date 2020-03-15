# TMDB 􏰀iOS App


## Overview
TMDB is an iOS movie app that showcases movies data sourced from https://www.themoviedb.org. This requires creating an account and obtaining an API key as per instructions in: https://developers.themoviedb.org/3/getting-started/introduction

The app does the following: 
- It displays a list of 'now playing' movies using data fetched from themoviedb.org. As user scrolls down it fetches more data from the API pagewise. 
- On selecting a movie, it navigates to another screen showing movie details like: title, release date, description and also list of similar movies.
- On selecting a movie from list of similar movies, the screen refreshes itself. 

### Additional details
- The app uses Apple developer recommended approach to cache and fetch images from URL for optimized performance. 
- CollectionView prefetching is used for smoother background fetch of data to be displayed on upcoming cells as user scrolls. 
- Basic unit and UI test cases are provided. 
     