
options(shiny.maxRequestSize = 200*1024^2)

shinyServer(function(input, output, session) {
  
  source("plotBinmap.R")
  source("genoConv.R")
  source("aovQTL.R")
  source("binQTLScan.R")
  source("kinship.R")
  source("randomFunction.R")
  source("plotQTL.R")
  
 
  
  # Genotype data
  data.G <- NULL
  observe({
    if (input$submit2>0) {
      isolate({
        if(input$dataGInput==1){
          if(input$sampleDataG==1){
            data.G <<- read.csv("ril.geno.csv", as.is=TRUE)
          } else {
            data.G <<- read.csv("imf2.geno.csv", as.is=TRUE)
          }
        } else if(input$dataGInput==2){
          inFile <- input$uploadG
          if (is.null(input$uploadG))  {data.G <<- NULL}
          data.G <<- read.csv(inFile$datapath, as.is=TRUE)
        }
        
        bin.height <- input$binHeight
        bin.width <- input$binWidth
        ge.xlab <- input$geXlab
        ge.main <- input$geTitle
        ge.ylab <- input$geYlab
        
        # binmap 
        output$binmap <- renderPlot({
          print(class(data.G))
          plotBinmap(data.G, xlab=ge.xlab, ylab=ge.ylab, main=ge.main)
        }, height = bin.height, width = bin.width)
      })
    } else {NULL}
  })
  
  
  # Phenotype data
  data.P <- NULL
  observe({
    if (input$submit3>0) {
      isolate({
        if(input$dataPInput==1){
          if(input$sampleDataP==1){
            data.P <<- read.csv("ril.phe.csv", as.is=TRUE)
          } else {
            data.P <<- read.csv("imf2.phe.csv", as.is=TRUE)
          }
        } else if(input$dataPInput==2){
          inFile <- input$uploadP
          if (is.null(input$uploadP))  {data.P <<- NULL}
          data.P <<- read.csv(inFile$datapath, as.is=TRUE)
        }
        
        phe.height <- input$pheHeight
        phe.width <- input$pheWidth
        phe.xlab <- input$pheXlab
        phe.main <- input$pheTitle
        phe.ylab <- input$pheYlab
        
        # pheno
        output$pheno <- renderPlot({
          print(class(data.P))
          hist(data.P[,2], ylab=phe.ylab, xlab=phe.xlab, main=phe.main)
        }, height = phe.height, width = phe.width)
      })  
    } else {NULL}
    
  })
	
  
	## QTL results in tables
  qtl.res <- NULL
	observe({
		if (input$submit1>0) {
			isolate({
			  if (input$qtlApp==1) {
			    qtl.res <<- aovQTL(phenotype=data.P, genotype=data.G)
			  } else {
			    if (input$popInput==1) {
			      qtl.res <<- binQTLScan(phenotype=data.P, genotype=data.G)
			      qtl.res <<- qtl.res[, c(1:4, 16:17, 19:23)]
			    } else {
			      qtl.res <<- binQTLScan(phenotype=data.P, genotype=data.G, population = "F2")
			      qtl.res <<- qtl.res[, c(1:4, 18:20, 22:26)]
			    }
			  }
			  
		  	output$qtltable <- renderTable({
	        qtl.res
	      })
		  })
		} else {NULL}
	})
	

	## QTL results in figures
	qtl.res.fil <- NULL
	observe({
	  if (input$submit4>0) {
	    isolate({
	      if (input$qtlApp==1) {
	        qtl.res.fil <<- qtl.res[, c(1:4, 6)]
	      } else {
	        qtl.res.fil <<- qtl.res[, c("Bin", "Chr", "Start", "Stop", "logplrt")]
	      }
	      
	      # The plot dimensions
	      heightSize <- input$myHeight
	      widthSize <- input$myWidth
	      
	      output$qtlfigure <- renderPlot({
	        myQtlCol <- gsub("\\s","", strsplit(input$qtlCol,",")[[1]])
	        myQtlCol <- gsub("0x","#", myQtlCol)
	        plotQTL(qtl.res.fil, ylab=expression(-log[10](p)), xlab=input$myXlab, 
	                main=input$myTitle, cex.main=input$cexTitle/10, cex.lab=input$cexAxislabel/10,
	                sub=input$mySubtitle, cex.axis=input$cexAxis/10, cols=myQtlCol)
	        
	      }, height = heightSize, width = widthSize)
	    })
	  } else {NULL}
	})

	## *** Download PDF file ***
	output$downloadPlotPDF <- downloadHandler(
	  filename <- function() { paste('QTL.pdf') },
	  content <- function(file) {
	    pdf(file, width = input$myWidth/72, height = input$myHeight/72)
	    plotQTL(qtl.res.fil, ylab=expression(-log[10](p)))
	    dev.off()
	  }, contentType = 'application/pdf')
	
	## *** Download SVG file ***
	output$downloadPlotSVG <- downloadHandler(
	  filename <- function() { paste('QTL.svg') },
	  content <- function(file) {
	    svg(file, width = input$myWidth/72, height = input$myHeight/72)
	    plotQTL(qtl.res.fil, ylab=expression(-log[10](p)))
	    dev.off()
	  }, contentType = 'image/svg')

	# *** Download QTL mapping results in csv format ***
	output$downloadQtlRes <- downloadHandler(
	  filename = function() { "QTL.res.csv" },
	  content = function(file) {
	    write.csv(qtl.res, file, row.names=FALSE)
	  })


	

})



