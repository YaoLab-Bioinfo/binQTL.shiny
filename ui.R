
shinyUI(pageWithSidebar(

	headerPanel("binQTL: QTL mapping with binmap data",
		tags$head(tags$style(type="text/css", "label.radio { display: inline-block; }", ".radio input[type=\"radio\"] { float: none; }"),
		tags$style(type="text/css", "select { max-width: 200px; }"),
		tags$style(type="text/css", "textarea { max-width: 185px; }"),
		tags$style(type="text/css", ".jslider { max-width: 200px; }"),
		tags$style(type='text/css', ".well { max-width: 330px; }"),
		tags$style(type='text/css', ".span4 { max-width: 330px; }")) 
	),
  
	sidebarPanel(
		conditionalPanel(condition="input.tabs1=='About'",
			h4("Introduction")
		),
		
		conditionalPanel(condition="input.tabs1=='Genotype Data'",
			h4("Enter genotype data"),
			radioButtons("dataGInput", "", list("Load sample data"=1,"Upload file"=2)),
			conditionalPanel(condition="input.dataGInput=='1'",
				radioButtons("sampleDataG", "Load sample genotype data", list("Data of 210 RILs"=1,"Data of 278 IMF2s"=2))
			),
			conditionalPanel(condition="input.dataGInput=='2'",
				h5("Upload genotype data: "),
				fileInput("uploadG", "", multiple = FALSE),
				HTML('<p>Data in .csv format</p>')
			),

			HTML('<br>'),
			
			h4("Plot options"),
			checkboxInput("genoTitle", "Modify labels and title", FALSE),
			conditionalPanel(condition="input.genoTitle",
				textInput("geXlab", "X-axis label:", value=c("Genomic position")),
				textInput("geYlab", "Y-axis label:", value=c("")),
				textInput("geTitle", "Main title:", value=c("Genetic binmap"))
			),

			checkboxInput("binmapSize", "Adjust plot size", FALSE),
			conditionalPanel(condition="input.binmapSize",
				numericInput("binHeight", "Plot height:", value=550),
				numericInput("binWidth", "Plot width:", value=750)
			),
			
				 
			HTML('<br>'),
	 		actionButton("submit2", strong("Go!"))
			
		),
		
		conditionalPanel(condition="input.tabs1=='Phenotype Data'",
			h4("Enter phenotype data"),
			radioButtons("dataPInput", "", list("Load sample data"=1,"Upload file"=2)),
			conditionalPanel(condition="input.dataPInput=='1'",
				radioButtons("sampleDataP", "Load sample phenotype data", list("Data of 210 RILs"=1,"Data of 278 IMF2s"=2))
			),
			conditionalPanel(condition="input.dataPInput=='2'",
				h5("Upload phenotype data: "),
				fileInput("uploadP", "", multiple = FALSE),
				HTML('<p>Data in .csv format</p>')
			),

			HTML('<br>'),

			h4("Plot options"),
			checkboxInput("phenoTitle", "Modify labels and title", FALSE),
			conditionalPanel(condition="input.phenoTitle",
				textInput("pheXlab", "X-axis label:", value=c("")),
				textInput("pheYlab", "Y-axis label:", value=c("Frequency")),
				textInput("pheTitle", "Main title:", value=c("Phenotype distribution"))
			),

			checkboxInput("pheSize", "Adjust plot size", FALSE),
			conditionalPanel(condition="input.pheSize",
				numericInput("pheHeight", "Plot height:", value=550),
				numericInput("pheWidth", "Plot width:", value=750)
			),

			HTML('<br>'),
			
			actionButton("submit3", strong("Go!"))
			
		),

		conditionalPanel(condition="input.tabs1=='QTL mapping'",
		    h4("Algorithm for QTL mapping"),
		    radioButtons("qtlApp", "", list("ANOVA"=1, "binQTL"=2)),
		    HTML('<br>'),
		    conditionalPanel(condition="input.qtlApp=='2'",
			h4("Population type"),
		    	radioButtons("popInput", "", list("RIL population"=1,"F2 population"=2))	
		    ),
		    
		    HTML('<br>'),
		    actionButton("submit1", strong("Go!"))
		),
		
		conditionalPanel(condition="input.tabs1=='QTL visualization'",

			h4("Plot options"),

			textInput("qtlCol", "Colour(s):", value=c("grey30, grey70")),
#			h5("Y-axis range (eg., '0,10'):"),
#			textInput("ylimit", "", value=""),

			checkboxInput("labelsTitle", "Modify labels and title", FALSE),
			conditionalPanel(condition="input.labelsTitle",
				textInput("myXlab", "X-axis label:", value=c("")),
				textInput("myTitle", "QTL title:", value=c("")),
				textInput("mySubtitle", "QTL subtitle:", value=c(""))
			),
			checkboxInput("plotSize", "Adjust plot size", FALSE),
			conditionalPanel(condition="input.plotSize",
				numericInput("myHeight", "Plot height:", value=550),
				numericInput("myWidth", "Plot width:", value=750)
			),
			checkboxInput("fontSizes", "Change font sizes", FALSE),
			conditionalPanel(condition="input.fontSizes",
				numericInput("cexTitle", "Title font size:", value=14),
				numericInput("cexAxislabel", "Axis label size:", value=14),
				numericInput("cexAxis", "Axis font size:", value=12)
			),
			
			HTML('<br>'),
 		        actionButton("submit4", strong("Go!"))
		)	
	),
  
	mainPanel(
		tabsetPanel(
			# Welcome tab
			tabPanel("About",
				h4("Software references"),
				HTML('<p>R Development Core Team. <i><a href="http://www.r-project.org/">R</a>:  A Language and Environment for Statistical Computing.</i> R Foundation for Statistical Computing, Vienna (2013) <br>
				RStudio and Inc. <i><a href="http://www.rstudio.com/shiny/">shiny</a>: Web Application Framework for R.</i> R package version 0.5.0 (2013) <br>
				Neuwirth, E. <i><a href="http://cran.r-project.org/web/packages/RColorBrewer/index.html">RColorBrewer</a>: ColorBrewer palettes.</i> R package version 1.0-5. (2011)</p>'),
				h4("Further references"),
				h6("This application was created by ", a("Wen Yao", href="https://www.researchgate.net/profile/Wen_Yao"), " and ", a("Shizhong Xu", href="http://cepceb.ucr.edu/people/xu-s.html"), 
				" . Please send bugs and feature requests to Wen Yao (ywhzau at gmail.com). This application uses the ", 
				a("shiny package from RStudio", href="http://www.rstudio.com/shiny/"), ".")
			),

			# Genotype Data upload tab
			tabPanel("Genotype Data", 
			    plotOutput("binmap", height='100%', width='100%'),
				h6("This application was created by ", a("Wen Yao", href="https://www.researchgate.net/profile/Wen_Yao"), " and ", a("Shizhong Xu", href="http://cepceb.ucr.edu/people/xu-s.html"), 
				" . Please send bugs and feature requests to Wen Yao (ywhzau at gmail.com). This application uses the ", 
				a("shiny package from RStudio", href="http://www.rstudio.com/shiny/"), ".")
			),

			# Phenotype Data upload tab
			tabPanel("Phenotype Data", 
			    plotOutput("pheno", height='100%', width='100%'),
				h6("This application was created by ", a("Wen Yao", href="https://www.researchgate.net/profile/Wen_Yao"), " and ", a("Shizhong Xu", href="http://cepceb.ucr.edu/people/xu-s.html"), 
				" . Please send bugs and feature requests to Wen Yao (ywhzau at gmail.com). This application uses the ", 
				a("shiny package from RStudio", href="http://www.rstudio.com/shiny/"), ".")
			),

			# QTL mapping
			tabPanel("QTL mapping",
				downloadButton("downloadQtlRes", "Download QTL mapping results as .CSV file"), 
				tableOutput("qtltable"),
				h6("This application was created by ", a("Wen Yao", href="https://www.researchgate.net/profile/Wen_Yao"), " and ", a("Shizhong Xu", href="http://cepceb.ucr.edu/people/xu-s.html"), 
				" . Please send bugs and feature requests to Wen Yao (ywhzau at gmail.com). This application uses the ", 
				a("shiny package from RStudio", href="http://www.rstudio.com/shiny/"), ".")
			),

			# QTL visualization
			tabPanel("QTL visualization", 
				downloadButton("downloadPlotPDF", "Download pdf-file"),
				downloadButton("downloadPlotSVG", "Download svg-file"),
				plotOutput("qtlfigure", height='100%', width='100%'),

				h6("This application was created by ", a("Wen Yao", href="https://www.researchgate.net/profile/Wen_Yao"), " and ", a("Shizhong Xu", href="http://cepceb.ucr.edu/people/xu-s.html"), 
				" . Please send bugs and feature requests to Wen Yao (ywhzau at gmail.com). This application uses the ", 
				a("shiny package from RStudio", href="http://www.rstudio.com/shiny/"), ".")
			), 

			# FAQ 
			tabPanel("FAQ",
				h5("Q:"), 
				p("A:"),

				h6("This application was created by ", a("Wen Yao", href="https://www.researchgate.net/profile/Wen_Yao"), " and ", a("Shizhong Xu", href="http://cepceb.ucr.edu/people/xu-s.html"), 
				" . Please send bugs and feature requests to Wen Yao (ywhzau at gmail.com). This application uses the ", 
				a("shiny package from RStudio", href="http://www.rstudio.com/shiny/"), ".")
			),			
			id="tabs1"
		)
	)
))







