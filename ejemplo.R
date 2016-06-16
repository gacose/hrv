library("RHRV")
hrv.data = CreateHRVData()

datos<-read.csv("Datos/ach.csv", TRUE )
x<-!is.na(datos$a)
y = datos$a[x]

rr <- y/1000
beats<-c(y[1]/1000)
for(i in 2:length(y)){
  beats[i]<-beats[i-1]+y[2]/1000
}
columna<-as.data.frame(beats)
write.csv(columna,"Datos/ach-beats.csv",row.names = FALSE)

hrv.data = SetVerbose(hrv.data, TRUE )
hrv.data = LoadBeatAscii(hrv.data,"ach-beats.csv",RecordPath = "Datos")

#hrv.data = FilterNIHR(hrv.data)
#esta función filtra datos espurios
hrv.data$RR = rr

hrv.data = InterpolateNIHR(hrv.data, freqhr = 4)
 PlotNIHR(hrv.data)

plot(hrv.data$HR)

PlotHR(hrv.data)

plot(beats,rr)

hrv.data<-LoadBeatRR(hrv.data, "ach-beats.csv",RecordPath = "Datos", scale = 1)
hrv.data = CreateFreqAnalysis(hrv.data)
hrv.data$FreqAnalysis
hrv.data = CalculatePowerBand( hrv.data , indexFreqAnalysis= 1, size = 300, shift = 30, sizesp = 2048, type = "fourier",ULFmin = 0, ULFmax = 0.03, VLFmin = 0.03, VLFmax = 0.05,LFmin = 0.05, LFmax = 0.15, HFmin = 0.15, HFmax = 0.4 )

fRR = hrv.data$Beat$RR
names(hrv.data$Beat)

hrv.data = CreateTimeAnalysis(hrv.data, size = 300,interval = 7.8125)
