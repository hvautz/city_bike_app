library(shiny)
library(rCharts)

shinyServer(function(input, output) {
   
   
   # Making the data set reactive with the inputs from UI. User selects,
   # which points to include on the map by StationID range.
   stationData <- reactive({
      input$btn_upd
      isolate({ 
               dataset <- subset(dat
                  , ( start.station.id >= min(input$stationSlider) &
                        start.station.id <= max(input$stationSlider))
                  , select=c(start.station.latitude
                     , start.station.longitude
                     , start.station.id
                     , start.station.name
                  )
               )
               dataset <- unique(dataset)
               return(dataset)
             })
   })
   
   ## select corresponding data and needed attributes to display the data
   bikeData <- reactive({
      dataset <- subset(dat
         , (bikeid == input$bikeSelect)
         , select=c(starttime
            , stoptime
            , start.station.latitude
            , start.station.longitude
            , start.station.id
            , start.station.name
            , end.station.latitude
            , end.station.longitude
            , end.station.id
            , end.station.name
            , col
         )
      )
      dataset <- dataset[order(dataset$starttime), ]
      #dataset$nr <- dataset[0, "start.station.id"]
      if (nrow(dataset) > 0) { 
         dataset[, "nr"] <- 1:nrow(dataset) }

      return(dataset)
   })
   
   
   # simple helper function
   # to center the map according to all selected
   # coordinates by mean lat and long
   getMapCenter <- function(stations){
      lat = mean(stations[,"start.station.latitude"])
      lng = mean(stations[,"start.station.longitude"])
      return(list(lat = lat, lng = lng))
   }
   
   
   #### Station Chart ####
   output$StationChart <- renderMap({
      map <- Leaflet$new()
      data_ <- stationData()
      center_ <- getMapCenter(data_)
      
      # setView to centre of dataset-points
      map$setView(c(center_$lat, center_$lng), zoom=13)
      
      # plot selected stations
      for (i in 1:nrow(data_))
      {
         map$marker( c(data_[i,"start.station.latitude"]
            , data_[i,"start.station.longitude"])
            , bindPopup = paste0("Station (ID-", data_[i,"start.station.id"], "): ",data_[i,"start.station.name"])
         )
      }
      
      map$tileLayer(provider = 'Esri.WorldImagery')
      map$set(width = 1000, height = 600)
      map$enablePopover(TRUE)
      map$fullScreen(TRUE)
      return(map)
   })
   
   #### Bike History Chart ####
   
   output$BikeHistChart <- renderMap({
      data_  <- bikeData()
      center_ <- getMapCenter(data_)

      # create new leaflet instance
      L1 <- Leaflet$new()
      
      # return empty map if no data selected
      if (nrow(data_) < 1) { 
         return(L1)
      }

      # get all start/end-points in a list
      for (i in 1:nrow(data_)) {
         if (i == 1) 
         {
            list <- paste0("[[", data_[i,]$start.station.latitude, ",", data_[i,]$start.station.longitude, "],"
               , "[", data_[i,]$end.station.latitude, ",", data_[i,]$end.station.longitude, "]")
         }
         if (i < nrow(data_) & i > 1)
         {
            list <- paste0(list
               , ", [", data_[i,]$start.station.latitude, ",", data_[i,]$start.station.longitude, "],"
               , "[", data_[i,]$end.station.latitude, ",", data_[i,]$end.station.longitude, "]")
         }
         if (i == nrow(data_))
         {
            list <- paste0(list, "]")
         }
      }

      # convert data_ to JSON-Array
      data_ <- toJSONArray2(data_, json = F)
      
      # setView to centre of dataset-points
      L1$setView(c(center_$lat, center_$lng), zoom=14)

      # set geoJSON
      L1$geoJson(toGeoJSON(data_, lat = 'start.station.latitude', lon = 'start.station.longitude')
               , pointToLayer = paste0("#! function(feature){
                  return L.polyline(", list, "
                                  , {
                                     color: 'red'
                                   , weight: 2
                                   , fillOpacity: 0.8
                                    }
                                   )
         } !#")
      )
   
      L1$set(width = 1000, height = 600)
      L1$tileLayer(provider = 'Esri.WorldImagery')
      return(L1)
   })
   
   #### Bike History Chart 2 ####
   
   output$BikeHistChart2 <- renderMap({
      data_  <- bikeData()
      center_ <- getMapCenter(data_)
      
      # create new leaflet instance
      L1 <- Leaflet$new()
      
      # return empty map if no data selected
      if (nrow(data_) < 1) { 
         return(L1)
      }
      
      # create the popup information
      data_[, "popup"] <- paste0("Station (ID-", data_[, "start.station.id"], "): ", data_[, "start.station.name"]
         , "<br />Stoptime: ", data_[,"starttime"]
         , "<br />Starttime: ", data_[,"stoptime"]
         , "<br />Nr: ", data_[,"nr"])
      
      # convert data_ to JSON-Array to draw circleMarkers correctly
      data_ <- toJSONArray2(data_, json = F)
      
      # setView to centre of dataset-points
      L1$setView(c(center_$lat, center_$lng), zoom=14)
      
      # set geoJSON
      L1$geoJson(toGeoJSON(data_
                         , lat = 'start.station.latitude'
                         , lon = 'start.station.longitude')
               , onEachFeature = '#! function(feature, layer)
                                    {
                                     layer.bindPopup(feature.properties.popup)
                                    } !#'
               , pointToLayer =  "#! function(feature, latlng)
                                    {
                                     return L.circleMarker(latlng
                                          , {
                                             radius: 4
                                           , fillColor: feature.properties.col
                                           , color: '#000'
                                           , weight: 1
                                           , fillOpacity: 0.8
                                            }
                                     )
                                   } !#"
      )
      
      
      L1$set(width = 1000, height = 600)
      L1$tileLayer(provider = 'Esri.WorldImagery')
      return(L1)
   })
})


