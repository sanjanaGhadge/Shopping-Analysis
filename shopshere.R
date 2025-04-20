library(shiny)
library(shinydashboard)
library(plotly)
library(dplyr)
library(readr)
library(leaflet)
library(DT)



# Load Dataset
shop <- read_csv('shopping_trends_updated.csv', show_col_types = FALSE)

location_data <- data.frame(
  Location = c("Maryland", "Georgia", "Maine", "Massachusetts", "Hawaii", 
               "Illinois", "North Dakota", "New Mexico", "North Carolina", 
               "Indiana", "New Jersey", "Montana", "California", 
               "Idaho", "Nevada", "Alabama"),
  Total_Purchase_Amount = c(4795, 4645, 4388, 4384, 3752, 5617, 5220, 
                            5014, 4742, 4655, 3802, 5784, 5605, 5587, 
                            5514, 5261),
  lat = c(39.0458, 33.7490, 44.2685, 42.4072, 21.3069, 40.6331, 47.5289, 
          34.5199, 35.6301, 40.5513, 40.0583, 46.8797, 36.7783, 43.6150, 
          38.8026, 32.8067),
  lng = c(-76.6413, -84.3880, -68.2047, -71.3824, -157.8583, -89.3985, 
          -99.7840, -106.2485, -79.8083, -87.6377, -74.4057, -110.3626, 
          -119.4179, -116.2023, -117.1947, -86.9023)
)

# Define UI
ui <- dashboardPage(
  skin = "purple",
  
  # Header
  dashboardHeader(title = "ShopSphere: 360° Shopping Analysis", titleWidth = 350),
  
  # Sidebar
  dashboardSidebar(
    sidebarMenu(
      menuItem("Welcome", tabName = "welcome", icon = icon("home")),
      menuItem("Dashboard", tabName = "dashboard", icon = icon("chart-bar")),
      menuItem("Sales Performance", tabName = "sales", icon = icon("line-chart")),
      menuItem("Customer trends", tabName = "customers", icon = icon("users")),
      menuItem("Inventory Management", tabName = "inventory", icon = icon("box")),
      menuItem("Marketing Insights", tabName = "Marketing", icon = icon("bullhorn")),
      menuItem("Store Operations", tabName = "store", icon = icon("store")),
      menuItem("Map", tabName = "map", icon = icon("map")),
      menuItem("View Dataset", tabName = "dataset", icon = icon("table")),
      menuItem("About", tabName = "about", icon = icon("info-circle")),
      menuItem("Conclusion", tabName = "conclusion", icon = icon("check-circle"))
    )
  ),
  # Body
  dashboardBody(
    # Custom Styling
    tags$head(
      tags$style(HTML("
        .main-header .logo {
          font-family: 'Arial Black', sans-serif;
          font-size: 20px;
        }
        .skin-purple .main-header .logo {
          background-color: #6A1B9A;
          color: white;
        }
        .skin-purple .main-header .navbar {
          background-color: #6A1B9A;
        }
        .skin-purple .main-sidebar {
          background-color: #4A148C;
        }
        .skin-purple .main-sidebar .sidebar-menu > li.active > a {
          background-color: #8E24AA;
        }
        .content-wrapper {
          background: linear-gradient(to right, #F3E5F5, #E1BEE7);
        }
        .box {
          background: white;
          border-radius: 15px;
          box-shadow: 5px 5px 10px #ccc;
        }
         .box-title {
        color: black !important;
         }
      
       #conclusion-text {
      font-size: 18px;
      font-family: 'Arial', sans-serif;
      line-height: 1.6;
      color: #333;
      text-align: justify;
      padding: 10px;
      background-color: #f9f9f9;
      border-radius: 8px;
      box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
    }
      ")),
      
      # JavaScript for Speech Synthesis
      tags$script(HTML("
  var currentAudio = null; // Track the current audio

  // Function to load voices and speak
  function loadVoicesAndSpeak(text, langCode) {
    var voices = speechSynthesis.getVoices();
    var selectedVoice = voices.find(voice => voice.lang === langCode) || voices.find(voice => voice.lang.includes('en'));

    if (selectedVoice) {
      var msg = new SpeechSynthesisUtterance(text);
      msg.voice = selectedVoice;
      msg.lang = selectedVoice.lang;
      msg.rate = 1;
      currentAudio = msg;
      window.speechSynthesis.speak(msg);
    } else {
      console.error('No suitable voice found for', langCode);
    }
  }

  // Ensure voices are loaded
  function ensureVoicesLoaded(callback) {
    var voices = speechSynthesis.getVoices();
    if (voices.length > 0) {
      callback();
    } else {
      window.speechSynthesis.onvoiceschanged = function() {
        var voices = speechSynthesis.getVoices();
        if (voices.length > 0) {
          callback();
        }
      };
    }
  }

  // Stop audio function
  function stopAudio() {
    if (currentAudio) {
      window.speechSynthesis.cancel();
      currentAudio = null;
    }
  }

  $(document).ready(function() {
    // Auto-play welcome message after 1 second
    setTimeout(function() {
      var welcomeMessage = 'Welcome to ShopSphere. A 360-degree Analysis project. This project analyzes shopping trends to provide insights into consumer behavior and preferences. Designed and created by Sanjana.';
      var langCode = 'en-US';
      ensureVoicesLoaded(() => loadVoicesAndSpeak(welcomeMessage, langCode));
    }, 1000);

    // Play Welcome Audio
    $('#play_welcome_audio').click(function() {
      var welcomeMessage = 'Welcome to ShopSphere. A 360-degree Analysis project. This project analyzes shopping trends to provide insights into consumer behavior and preferences. Designed and created by Sanjana.';
      var langCode = 'en-US';
      ensureVoicesLoaded(() => loadVoicesAndSpeak(welcomeMessage, langCode));
    });

    // Stop Welcome Audio
    $('#stop_welcome_audio').click(function() {
      stopAudio();
    });

    // Play About Audio
    $('#play_audio').click(function() {
      // Stop any ongoing audio before starting new audio
      stopAudio();
      var aboutText = $('#about-text').text();
      var langCode = 'en-US';
      ensureVoicesLoaded(() => loadVoicesAndSpeak(aboutText, langCode));
    });

    // Stop About Audio
    $('#stop_audio').click(function() {
      stopAudio();
    });

    // Play Conclusion Audio
    $('#play_conclusion_audio').click(function() {
      var conclusionText = $('#conclusion-text').text();
      var langCode = 'en-US';
      ensureVoicesLoaded(() => loadVoicesAndSpeak(conclusionText, langCode));
    });

    // Stop Conclusion Audio
    $('#stop_conclusion_audio').click(function() {
      stopAudio();
    });
  });
"))
      
      
),
    
    
    
    tabItems(
      tabItem(tabName = "welcome",
              div(
                style = "display: flex; flex-direction: column; align-items: center; justify-content: center; 
                   width: 100%; height: auto; text-align: center; padding: 5%; background: linear-gradient(135deg, #1B1B2F, #162447);",
                
                # Content Box (Ensuring Centered Alignment)
                div(
                  style = "max-width: 800px; width: 90%; background: rgba(255, 255, 255, 0.1); 
                     border-radius: 15px; padding: 25px; box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.3);",
                  
                  tags$h1("🚀 Welcome to ShopSphere!", 
                          style = "font-weight: bold; font-size: clamp(28px, 8vw, 48px); color: #F39C12; margin-bottom: 10px;"),
                  
                  tags$p("A 360° Shopping Analysis Project", 
                         style = "font-size: clamp(18px, 5vw, 24px); font-style: italic; color: #ECF0F1; margin-bottom: 15px;"),
                  
                  tags$p("This project analyzes shopping trends and provides insights into customer behavior and preferences.", 
                         style = "font-size: clamp(16px, 4vw, 20px); margin: 20px auto; color: #ECF0F1;"),
                  
                  tags$p("Designed and created by:", 
                         style = "font-size: clamp(18px, 5vw, 22px); color: #F7DC6F; font-weight: bold; margin-bottom: 10px;"),
                  
                  tags$p("Sanjana", 
                         style = "font-size: clamp(20px, 5vw, 24px); font-weight: bold; color: #F7DC6F; margin-bottom: 20px;"),
                  
                  # Buttons Section (Aligned Center)
                  div(style = "margin-top: 20px; display: flex; flex-direction: column; gap: 15px; justify-content: center; align-items: center; width: 100%;",
                      
                      # Play Audio Button
                      actionButton("play_welcome_audio", "🎵 Play Welcome Audio", icon = icon("play-circle"),
                                   style = "background-color: #1ABC9C; color: white; font-size: clamp(14px, 4vw, 18px); 
                                      padding: 12px 24px; border-radius: 12px; border: none; transition: all 0.3s ease-in-out;"),
                      
                      # Stop Audio Button
                      actionButton("stop_welcome_audio", "⏹ Stop Audio", icon = icon("stop-circle"),
                                   style = "background-color: #E74C3C; color: white; font-size: clamp(14px, 4vw, 18px); 
                                      padding: 12px 24px; border-radius: 12px; border: none; transition: all 0.3s ease-in-out;")
                  )
                )
              )
      ),
      
      
      
      
      # Map Tab
      tabItem(tabName = "map",
              fluidRow(
                box(title = "Location Purchase Amount Map", width = 12, leafletOutput("leaflet"))
              )
      ),
      
      #view dataset
      tabItem(tabName = "dataset",
              fluidRow(
                box(title = "Full Dataset", width = 12, status = "primary",
                    DTOutput("data_table"), solidHeader = TRUE)
              )),
      
      # Dashboard Tab
      tabItem(tabName = "dashboard",
              fluidRow(
                box(
                  title = "Select Analysis", width = 4, status = "primary", solidHeader = TRUE,
                  selectInput("analysis_option", "Choose an analysis",
                              choices = c(
                                "Age Distribution",
                                "Average Purchase by Category",
                                "Purchases by Gender",
                                "Popular Payment Methods",
                                "Promo Code Spending",
                                "Correlation: Size and Purchase Amount",
                                "Shipping Type by Category",
                                "Effect of Discounts",
                                "Popular Colors",
                                "Average Previous Purchases",
                                "Purchase Behavior by Location",
                                "Age and Product Categories",
                                "Purchase Amount by Gender"
                              ),
                              selected = "Age Distribution"
                  )
                ),
                box(
                  title = textOutput("analysis_title"), width = 8, status = "primary", solidHeader = TRUE,
                  plotlyOutput("analysis_plot", height = "400px")
                )
              )
      ),
      
      # Sales Tab
      tabItem(tabName = "sales",
              fluidRow(
                box(
                  title = "Select Analysis", width = 4, status = "primary", solidHeader = TRUE,
                  selectInput("analysis_option_sales", "Choose an analysis",
                              choices = c(
                                "Average Purchase by Category",
                                "Correlation: Size and Purchase Amount",
                                "Effect of Discounts",
                                "Purchase Amount by Gender"
                              ),
                              selected = "Effect of Discounts"
                  )
                ),
                box(
                  title = textOutput("analysis_title_sales"), width = 8, status = "primary", solidHeader = TRUE,
                  plotlyOutput("analysis_plot_sales", height = "400px")
                )
              )
      ),
      
      
      
      # Customer Analysis Tab
      tabItem(tabName = "customers",
              fluidRow(
                box(
                  title = "Select Analysis", width = 4, status = "primary", solidHeader = TRUE,
                  selectInput("analysis_option_customer", "Choose an analysis",
                              choices = c(
                                "Age Distribution",
                                "Purchases by Gender",
                                "Popular Payment Methods",
                                "Age and Product Categories"
                              ),
                              selected = "Age Distribution"
                  )
                ),
                box(
                  title = textOutput("analysis_title_customer"), width = 8, status = "primary", solidHeader = TRUE,
                  plotlyOutput("analysis_plot_customer", height = "400px")
                )
              )
      ),
      
      
      # Inventory tab
      tabItem(tabName = "inventory",
              fluidRow(
                box(
                  title = "Select Analysis", width = 4, status = "primary", solidHeader = TRUE,
                  selectInput("analysis_option_inventory", "Choose an analysis",
                              choices = c(
                                "Promo Code Spending",
                                "Shipping Type by Category",
                                "Effect of Discounts"
                              ),
                              selected = "Promo Code Spending"
                  )
                ),
                box(
                  title = textOutput("analysis_title_inventory"), width = 8, status = "primary", solidHeader = TRUE,
                  plotlyOutput("analysis_plot_inventory", height = "400px")
                )
              )
      ),

      # Conclusion Tab
      tabItem(tabName = "conclusion",
              fluidRow(
                box(
                  title = "Conclusion", width = 12, status = "primary", solidHeader = TRUE,
                  p(id = "conclusion-text", HTML("
              <b>Result Analysis:</b><br><br>
              <b>Distribution of Customer Ages:</b> Older and middle-aged adults dominate, likely due to higher purchasing power. Young adults and teens are underrepresented.<br><br>
              
              <b>Purchases by Gender:</b> Males spend significantly more than females. Marketing can focus on high-ticket items for men and engage females for loyalty.<br><br>
              
              <b>Category-Wise Purchases:</b> Clothing leads, followed by accessories. Retailers can focus on expanding clothing and trending accessories.<br><br>
              
              <b>Effect of Discounts:</b> Purchases drop when discounts aren't applied. Discounts influence spending, encouraging more purchases during sales.<br><br>
              
              <b>Popular Payment Methods:</b> Credit Cards (17%) are most used. Smooth transaction experiences with these methods can boost satisfaction.<br><br>
              
              <b>Promo Code Usage:</b> Purchases with promo codes show a slight decrease in total, indicating the need for balanced promotional strategies.<br><br>
              
              <b>Shipping Preferences:</b> Shipping options are diverse, catering to customer needs, improving convenience in their shopping experience.<br><br>
              
              <b>Popular Colors:</b> Olive, Yellow, and Silver are preferred. Highlighting these in product recommendations aligns with customer preferences.
            ")),
                  actionButton("play_conclusion_audio", "Read Conclusion"),
                  actionButton("stop_audio", "Stop Audio"),  # Added "Stop Audio" button
                  br(), br(),
                  p("Thank you for exploring the ShopSphere dashboard! Below you can download the detailed report as a PDF."),
                  h3("Download the full Report"),
                  downloadButton("download_pdf", "Download Report (PDF)", class = "btn-primary"),
                  tags$style(HTML("
        #download_report {
          color: white;
          background-color: #007bff;
          border-color: #007bff;
          font-size: 16px;
          padding: 10px 20px;
          border-radius: 8px;
        }
        #download_report:hover {
          background-color: #0056b3;
          border-color: #0056b3;
        }
      "))
                )
              )
      ),
      
      #Marketing tab
      tabItem(tabName = "Marketing",
              fluidRow(
                box(
                  title = "Select Analysis", width = 4, status = "primary", solidHeader = TRUE,
                  selectInput("analysis_option_marketing", "Choose an analysis",
                              choices = c(
                                "Shipping Type by Category",
                                "Popular Colors",
                                "Popular Payment Methods",
                                "Effect of Discounts"
                              ),
                              selected = "Popular Colors"
                  )
                ),
                box(
                  title = textOutput("analysis_title_marketing"), width = 8, status = "primary", solidHeader = TRUE,
                  plotlyOutput("analysis_plot_marketing", height = "400px")
                )
              )
      ),
      tabItem(tabName = "store",
              fluidRow(
                box(
                  title = "Select Analysis", width = 4, status = "primary", solidHeader = TRUE,
                  selectInput("analysis_option_store", "Choose an analysis",
                              choices = c(
                                "Purchase Behavior by Location",
                                "Age and Product Categories"
                              ),
                              selected = "Purchase Behavior by Location"
                  )
                ),
                box(
                  title = textOutput("analysis_title_store"), width = 8, status = "primary", solidHeader = TRUE,
                  plotlyOutput("analysis_plot_store", height = "400px")
                )
              )
      ),
      tabItem(tabName = "about",
              fluidRow(
                box(
                  title = "About ShopSphere", width = 12, status = "primary", solidHeader = TRUE,
                  
                  # Custom styles
                  tags$head(
                    tags$style(HTML("
          #about-text {
            font-size: 18px;
            font-family: 'Arial', sans-serif;
            line-height: 1.6;
            color: #333;
            text-align: justify;
            padding: 10px;
            background-color: #f9f9f9;
            border-radius: 8px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
          }
          .box-title {
            font-size: 22px;
            font-weight: bold;
            color: #4a90e2;
          }
          .box {
            background-color: #ffffff;
            border: 2px solid #4a90e2;
            border-radius: 8px;
          }
          .action-button {
            margin-top: 10px;
            padding: 8px 16px;
            font-size: 16px;
            background-color: #4a90e2;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
          }
          .action-button:hover {
            background-color: #357ab7;
          }
        "))
                  ),
                  
                  # About text
                  p(id = "about-text", HTML("
        <b>ShopSphere </b>is an advanced shopping analytics dashboard that provides valuable insights into customer behavior, purchasing patterns, and sales performance.<br><br>
        This dashboard helps businesses and retailers by offering:<br>
        <b>Trend Analysis</b>: Understand how shopping behaviors evolve over time.<br>
        <b>Customer Segmentation</b>: Identify different types of shoppers and their preferences.<br>
        <b>Sales Performance Insights</b>: Analyze product sales, seasonal trends, and revenue distribution.<br>
        <b>Marketing Impact</b>: Evaluate ad campaigns, customer engagement, and conversion rates.<br>
        <b>Inventory Management</b>: Optimize stock levels and forecast future demand.<br><br>
        Built using R, Shiny, Plotly, and shinydashboard, ShopSphere delivers a dynamic and interactive experience, allowing users to explore data in an intuitive way.<br><br>
        <i>Designed by: Sanjana<i>"
                  )),
                  
                  # Action buttons
                  actionButton("play_audio", "Read About", class = "action-button"),
                  actionButton("stop_conclusion_audio", "Stop Audio", class = "action-button")
                )
              )
      )
      
    )
  )
)

# Define Server Logic
server <- function(input, output, session) {
  
  # Render Analysis Title
  output$analysis_title <- renderText({
    input$analysis_option
  })
  
  # Render Plotly Analysis
  output$analysis_plot <- renderPlotly({
    req(input$analysis_option) # Ensure an analysis option is selected
    
    # Age Distribution
    if (input$analysis_option == "Age Distribution") {
      if ("Age" %in% colnames(shop)) {
        shop$Age_category <- cut(
          shop$Age,
          breaks = c(7, 15, 18, 30, 50, 70),
          labels = c('Child', 'Teen', 'Young Adults', 'Middle-Aged Adults', 'Old'),
          include.lowest = TRUE
        )
        fig <- plot_ly(
          data = shop,
          x = ~Age_category,
          type = "histogram",
          marker = list(color = 'steelblue')
        ) %>%
          layout(
            title = "Age Distribution of Shoppers",
            xaxis = list(title = "Age Category"),
            yaxis = list(title = "Number of Shoppers")
          )
      }
      return(fig)
    }
    # Average Purchase by Category
    
    else if (input$analysis_option == "Average Purchase by Category") {
      if ("Category" %in% colnames(shop) && "Purchase Amount (USD)" %in% colnames(shop)) {
        avg_purchase <- shop %>%
          group_by(Category) %>%
          summarise(avg_purchase = mean(`Purchase Amount (USD)`, na.rm = TRUE), .groups = 'drop')
        fig <- plot_ly(
          data = avg_purchase,
          x = ~Category,
          y = ~avg_purchase,
          type = 'bar'
        ) %>%
          layout(
            title = "Average Purchase Amount Across Categories",
            xaxis = list(title = "Category"),
            yaxis = list(title = "Average Purchase (USD)")
          )
        return(fig)
      } else {
        stop("Columns 'Category' or 'Purchase Amount (USD)' are missing.")
      }
      
      # Purchases by Gender
    } else if (input$analysis_option == "Purchases by Gender") {
      if ("Gender" %in% colnames(shop) && "Purchase Amount (USD)" %in% colnames(shop)) {
        gender_purchase <- shop %>%
          group_by(Gender) %>%
          summarise(total_purchase = sum(`Purchase Amount (USD)`, na.rm = TRUE))
        fig <- plot_ly(
          data = gender_purchase,
          x = ~Gender,
          y = ~total_purchase,
          type = 'bar'
        ) %>%
          layout(
            title = "Total Purchases by Gender",
            xaxis = list(title = "Gender"),
            yaxis = list(title = "Total Purchase (USD)")
          )
        return(fig)
      } else {
        stop("Columns 'Gender' or 'Purchase Amount (USD)' are missing.")
      }
      
      # Popular Payment Methods
    } else if (input$analysis_option == "Popular Payment Methods") {
      if ("Payment Method" %in% colnames(shop)) {
        payment_methods <- shop %>%
          count(`Payment Method`) %>%
          rename(Count = n)
        fig <- plot_ly(
          data = payment_methods,
          labels = ~`Payment Method`,
          values = ~Count,
          type = 'pie'
        ) %>%
          layout(title = "Payment Method Popularity")
        return(fig)
      } else {
        stop("Column 'Payment Method' is missing.")
      }
      
      # Promo Code Spending
    } else if (input$analysis_option == "Promo Code Spending") {
      if ("Promo Code Used" %in% colnames(shop) && "Purchase Amount (USD)" %in% colnames(shop)) {
        promo_spending <- shop %>%
          group_by(`Promo Code Used`) %>%
          summarise(total_spent = sum(`Purchase Amount (USD)`, na.rm = TRUE))
        fig <- plot_ly(
          data = promo_spending,
          x = ~`Promo Code Used`,
          y = ~total_spent,
          type = 'bar'
        ) %>%
          layout(
            title = "Promo Code Spending",
            xaxis = list(title = "Promo Code Used"),
            yaxis = list(title = "Total Spending (USD)")
          )
        return(fig)
      } else {
        stop("Columns 'Promo Code Used' or 'Purchase Amount (USD)' are missing.")
      }
      
      # Correlation: Size and Purchase Amount
    } else if (input$analysis_option == "Correlation: Size and Purchase Amount") {
      if ("Size" %in% colnames(shop) && "Purchase Amount (USD)" %in% colnames(shop)) {
        size_purchase <- shop %>%
          group_by(Size) %>%
          summarise(avg_purchase = mean(`Purchase Amount (USD)`, na.rm = TRUE))
        fig <- plot_ly(
          data = size_purchase,
          x = ~Size,
          y = ~avg_purchase,
          type = 'scatter',
          mode = 'markers'
        ) %>%
          layout(
            title = "Correlation: Size and Purchase Amount",
            xaxis = list(title = "Size"),
            yaxis = list(title = "Average Purchase (USD)")
          )
        return(fig)
      } else {
        stop("Columns 'Size' or 'Purchase Amount (USD)' are missing.")
      }
      
      # Shipping Type by Category
    } else if (input$analysis_option == "Shipping Type by Category") {
      if ("Shipping Type" %in% colnames(shop) && "Category" %in% colnames(shop)) {
        shipping_data <- shop %>%
          count(`Shipping Type`, Category)
        fig <- plot_ly(
          data = shipping_data,
          x = ~`Shipping Type`,
          y = ~n,
          color = ~Category,
          type = 'bar'
        ) %>%
          layout(
            title = "Shipping Type by Category",
            xaxis = list(title = "Shipping Type"),
            yaxis = list(title = "Count"),
            barmode = 'stack'
          )
        return(fig)
      } else {
        stop("Columns 'Shipping Type' or 'Category' are missing.")
      }
      
      # Effect of Discounts
    } else if (input$analysis_option == "Effect of Discounts") {
      if ("Discount Applied" %in% colnames(shop) && "Purchase Amount (USD)" %in% colnames(shop)) {
        discount_data <- shop %>%
          group_by(`Discount Applied`) %>%
          summarise(avg_purchase = mean(`Purchase Amount (USD)`, na.rm = TRUE))
        fig <- plot_ly(
          data = discount_data,
          x = ~`Discount Applied`,
          y = ~avg_purchase,
          type = 'bar'
        ) %>%
          layout(
            title = "Effect of Discounts",
            xaxis = list(title = "Discount Applied"),
            yaxis = list(title = "Average Purchase (USD)")
          )
        return(fig)
      } else {
        stop("Columns 'Discount Applied' or 'Purchase Amount (USD)' are missing.")
      }
      
      # Popular Colors
    } else if (input$analysis_option == "Popular Colors") {
      if ("Color" %in% colnames(shop)) {
        color_data <- shop %>%
          count(Color) %>%
          rename(Count = n)
        fig <- plot_ly(
          data = color_data,
          labels = ~Color,
          values = ~Count,
          type = 'pie'
        ) %>%
          layout(title = "Most Popular Colors")
        return(fig)
      } else {
        stop("Column 'Color' is missing.")
      }
      
      # Average Previous Purchases
    } else if (input$analysis_option == "Average Previous Purchases") {
      if ("Previous Purchases" %in% colnames(shop)) {
        avg_previous <- shop %>%
          summarise(avg_previous = mean(`Previous Purchases`, na.rm = TRUE))
        fig <- plot_ly(
          data = avg_previous,
          x = ~"Average Previous Purchases",
          y = ~avg_previous,
          type = 'bar'
        ) %>%
          layout(
            title = "Average Previous Purchases",
            xaxis = list(title = "Previous Purchases"),
            yaxis = list(title = "Average")
          )
        return(fig)
      } else {
        stop("Column 'Previous Purchases' is missing.")
      }
      
      # Purchase Behavior by Location
    } else if (input$analysis_option == "Purchase Behavior by Location") {
      if ("Location" %in% colnames(shop) && "Purchase Amount (USD)" %in% colnames(shop)) {
        location_behavior <- shop %>%
          group_by(Location) %>%
          summarise(total_purchase = sum(`Purchase Amount (USD)`, na.rm = TRUE))
        fig <- plot_ly(
          data = location_behavior,
          x = ~Location,
          y = ~total_purchase,
          type = 'bar'
        ) %>%
          layout(
            title = "Purchase Behavior by Location",
            xaxis = list(title = "Location"),
            yaxis = list(title = "Total Purchase (USD)")
          )
        return(fig)
      } else {
        stop("Columns 'Location' or 'Purchase Amount (USD)' are missing.")
      }
      
      # Age and Product Categories
    } else if (input$analysis_option == "Age and Product Categories") {
      if ("Age" %in% colnames(shop) && "Category" %in% colnames(shop)) {
        age_category_data <- shop %>%
          group_by(Age, Category) %>%
          summarise(total_purchase = sum(`Purchase Amount (USD)`, na.rm = TRUE), .groups = 'drop')
        fig <- plot_ly(
          data = age_category_data,
          x = ~Age,
          y = ~total_purchase,
          color = ~Category,
          type = 'bar'
        ) %>%
          layout(
            title = "Age and Product Categories",
            xaxis = list(title = "Age Category"),
            yaxis = list(title = "Total Purchase (USD)"),
            barmode = 'stack'
          )
        return(fig)
      } else {
        stop("Columns 'Age' or 'Category' are missing.")
      }
      
      # Purchase Amount by Gender
    } else if (input$analysis_option == "Purchase Amount by Gender") {
      if ("Gender" %in% colnames(shop) && "Purchase Amount (USD)" %in% colnames(shop)) {
        gender_purchase_amount <- shop %>%
          group_by(Gender) %>%
          summarise(total_purchase = sum(`Purchase Amount (USD)`, na.rm = TRUE))
        fig <- plot_ly(
          data = gender_purchase_amount,
          x = ~Gender,
          y = ~total_purchase,
          type = 'bar'
        ) %>%
          layout(
            title = "Purchase Amount by Gender",
            xaxis = list(title = "Gender"),
            yaxis = list(title = "Total Purchase (USD)")
          )
        return(fig)
      } else {
        stop("Columns 'Gender' or 'Purchase Amount (USD)' are missing.")
      }
    }
  })
  
  # Render Analysis Title for Inventory
  output$analysis_title_inventory <- renderText({
    input$analysis_option_inventory
  })
  
  # Render Plotly Analysis for Inventory
  output$analysis_plot_inventory <- renderPlotly({
    req(input$analysis_option_inventory) # Ensure an analysis option is selected
    
    # Promo Code Spending
    if (input$analysis_option_inventory == "Promo Code Spending") {
      if ("Promo Code Used" %in% colnames(shop) && "Purchase Amount (USD)" %in% colnames(shop)) {
        promo_spending <- shop %>%
          group_by(`Promo Code Used`) %>%
          summarise(total_spent = sum(`Purchase Amount (USD)`, na.rm = TRUE))
        fig <- plot_ly(
          data = promo_spending,
          x = ~`Promo Code Used`,
          y = ~total_spent,
          type = 'bar'
        ) %>%
          layout(
            title = "Promo Code Spending",
            xaxis = list(title = "Promo Code Used"),
            yaxis = list(title = "Total Spending (USD)")
          )
        return(fig)
      } else {
        stop("Columns 'Promo Code Used' or 'Purchase Amount (USD)' are missing.")
      }
    }
    
    # Shipping Type by Category
    else if (input$analysis_option_inventory == "Shipping Type by Category") {
      if ("Shipping Type" %in% colnames(shop) && "Category" %in% colnames(shop)) {
        shipping_data <- shop %>%
          count(`Shipping Type`, Category)
        fig <- plot_ly(
          data = shipping_data,
          x = ~`Shipping Type`,
          y = ~n,
          color = ~Category,
          type = 'bar'
        ) %>%
          layout(
            title = "Shipping Type by Category",
            xaxis = list(title = "Shipping Type"),
            yaxis = list(title = "Count"),
            barmode = 'stack'
          )
        return(fig)
      } else {
        stop("Columns 'Shipping Type' or 'Category' are missing.")
      }
      
      # Effect of Discounts
    } else if (input$analysis_option_inventory== "Effect of Discounts") {
      if ("Discount Applied" %in% colnames(shop) && "Purchase Amount (USD)" %in% colnames(shop)) {
        discount_data <- shop %>%
          group_by(`Discount Applied`) %>%
          summarise(avg_purchase = mean(`Purchase Amount (USD)`, na.rm = TRUE))
        fig <- plot_ly(
          data = discount_data,
          x = ~`Discount Applied`,
          y = ~avg_purchase,
          type = 'bar'
        ) %>%
          layout(
            title = "Effect of Discounts",
            xaxis = list(title = "Discount Applied"),
            yaxis = list(title = "Average Purchase (USD)")
          )
        return(fig)
      } else {
        stop("Columns 'Discount Applied' or 'Purchase Amount (USD)' are missing.")
      }
      
    } 
    
  })
  
  # For Marketing Tab
  output$analysis_title_marketing <- renderText({
    input$analysis_option_marketing
  })
  
  output$analysis_plot_marketing <- renderPlotly({
    req(input$analysis_option_marketing)  # Ensure an analysis option is selected
    
    if (input$analysis_option_marketing == "Popular Colors") {
      if ("Color" %in% colnames(shop)) {
        color_data <- shop %>%
          count(Color) %>%
          rename(Count = n)
        fig <- plot_ly(
          data = color_data,
          labels = ~Color,
          values = ~Count,
          type = 'pie'
        ) %>%
          layout(title = "Most Popular Colors")
        return(fig)
      } else {
        stop("Column 'Color' is missing.")
      }
    }
    # Shipping Type by Category
    else if (input$analysis_option_marketing == "Shipping Type by Category") {
      if ("Shipping Type" %in% colnames(shop) && "Category" %in% colnames(shop)) {
        shipping_data <- shop %>%
          count(`Shipping Type`, Category)
        fig <- plot_ly(
          data = shipping_data,
          x = ~`Shipping Type`,
          y = ~n,
          color = ~Category,
          type = 'bar'
        ) %>%
          layout(
            title = "Shipping Type by Category",
            xaxis = list(title = "Shipping Type"),
            yaxis = list(title = "Count"),
            barmode = 'stack'
          )
        return(fig)
      } else {
        stop("Columns 'Shipping Type' or 'Category' are missing.")
      }
      
      # Effect of Discounts
    } else if (input$analysis_option_marketing == "Effect of Discounts") {
      if ("Discount Applied" %in% colnames(shop) && "Purchase Amount (USD)" %in% colnames(shop)) {
        discount_data <- shop %>%
          group_by(`Discount Applied`) %>%
          summarise(avg_purchase = mean(`Purchase Amount (USD)`, na.rm = TRUE))
        fig <- plot_ly(
          data = discount_data,
          x = ~`Discount Applied`,
          y = ~avg_purchase,
          type = 'bar'
        ) %>%
          layout(
            title = "Effect of Discounts",
            xaxis = list(title = "Discount Applied"),
            yaxis = list(title = "Average Purchase (USD)")
          )
        return(fig)
      } else {
        stop("Columns 'Discount Applied' or 'Purchase Amount (USD)' are missing.")
      }
    }
    # Popular Payment Methods
    else if (input$analysis_option_marketing== "Popular Payment Methods") {
      if ("Payment Method" %in% colnames(shop)) {
        payment_methods <- shop %>%
          count(`Payment Method`) %>%
          rename(Count = n)
        fig <- plot_ly(
          data = payment_methods,
          labels = ~`Payment Method`,
          values = ~Count,
          type = 'pie'
        ) %>%
          layout(title = "Payment Method Popularity")
        return(fig)
      } else {
        stop("Column 'Payment Method' is missing.")
      }
      
    } 
    
  })
  
  
  #Sales performance
  # Render selected analysis title
  output$analysis_title_sales <- renderText({
    input$analysis_option_sales
  })
  
  # Render Plotly visualization for sales analysis
  output$analysis_plot_sales <- renderPlotly({
    req(input$analysis_option_sales)  # Ensure an option is selected
    
    # Average Purchase by Category
    if (input$analysis_option_sales == "Average Purchase by Category") {
      if ("Category" %in% colnames(shop) && "Purchase Amount (USD)" %in% colnames(shop)) {
        avg_purchase <- shop %>%
          group_by(Category) %>%
          summarise(avg_purchase = mean(`Purchase Amount (USD)`, na.rm = TRUE), .groups = 'drop')
        
        fig <- plot_ly(
          data = avg_purchase,
          x = ~Category,
          y = ~avg_purchase,
          type = 'bar'
        ) %>%
          layout(
            title = "Average Purchase Amount Across Categories",
            xaxis = list(title = "Category"),
            yaxis = list(title = "Average Purchase (USD)")
          )
        return(fig)
      }
    }
    
    # Correlation: Size and Purchase Amount
    else if (input$analysis_option_sales == "Correlation: Size and Purchase Amount") {
      if ("Size" %in% colnames(shop) && "Purchase Amount (USD)" %in% colnames(shop)) {
        size_purchase <- shop %>%
          group_by(Size) %>%
          summarise(avg_purchase = mean(`Purchase Amount (USD)`, na.rm = TRUE))
        
        fig <- plot_ly(
          data = size_purchase,
          x = ~Size,
          y = ~avg_purchase,
          type = 'scatter',
          mode = 'markers'
        ) %>%
          layout(
            title = "Correlation: Size and Purchase Amount",
            xaxis = list(title = "Size"),
            yaxis = list(title = "Average Purchase (USD)")
          )
        return(fig)
      }
    }
    
    # Effect of Discounts
    else if (input$analysis_option_sales == "Effect of Discounts") {
      if ("Discount Applied" %in% colnames(shop) && "Purchase Amount (USD)" %in% colnames(shop)) {
        discount_data <- shop %>%
          group_by(`Discount Applied`) %>%
          summarise(avg_purchase = mean(`Purchase Amount (USD)`, na.rm = TRUE))
        
        fig <- plot_ly(
          data = discount_data,
          x = ~`Discount Applied`,
          y = ~avg_purchase,
          type = 'bar'
        ) %>%
          layout(
            title = "Effect of Discounts",
            xaxis = list(title = "Discount Applied"),
            yaxis = list(title = "Average Purchase (USD)")
          )
        return(fig)
      }
    }
    
    # Purchase Amount by Gender
    else if (input$analysis_option_sales == "Purchase Amount by Gender") {
      if ("Gender" %in% colnames(shop) && "Purchase Amount (USD)" %in% colnames(shop)) {
        gender_purchase_amount <- shop %>%
          group_by(Gender) %>%
          summarise(total_purchase = sum(`Purchase Amount (USD)`, na.rm = TRUE))
        
        fig <- plot_ly(
          data = gender_purchase_amount,
          x = ~Gender,
          y = ~total_purchase,
          type = 'bar'
        ) %>%
          layout(
            title = "Purchase Amount by Gender",
            xaxis = list(title = "Gender"),
            yaxis = list(title = "Total Purchase (USD)")
          )
        return(fig)
      }
    }
  })
  
  # Render selected analysis title
  output$analysis_title_customer <- renderText({
    input$analysis_option_customer
  })
  
  # Render Plotly visualization for customer analysis
  output$analysis_plot_customer <- renderPlotly({
    req(input$analysis_option_customer)  # Ensure an option is selected
    
    # Age Distribution
    if (input$analysis_option == "Age Distribution") {
      if ("Age" %in% colnames(shop)) {
        shop$Age_category <- cut(
          shop$Age,
          breaks = c(7, 15, 18, 30, 50, 70),
          labels = c('Child', 'Teen', 'Young Adults', 'Middle-Aged Adults', 'Old'),
          include.lowest = TRUE
        )
        fig <- plot_ly(
          data = shop,
          x = ~Age_category,
          type = "histogram",
          marker = list(color = 'steelblue')
        ) %>%
          layout(
            title = "Age Distribution of Shoppers",
            xaxis = list(title = "Age Category"),
            yaxis = list(title = "Number of Shoppers")
          )
      }
      return(fig)
    }
    
    # Purchases by Gender (Bar Chart)
    else if (input$analysis_option_customer == "Purchases by Gender") {
      if ("Gender" %in% colnames(shop) && "Purchase Amount (USD)" %in% colnames(shop)) {
        gender_purchases <- shop %>%
          group_by(Gender) %>%
          summarise(total_purchases = sum(`Purchase Amount (USD)`, na.rm = TRUE))
        
        fig <- plot_ly(
          data = gender_purchases,
          x = ~Gender,
          y = ~total_purchases,
          type = 'bar'
        ) %>%
          layout(
            title = "Total Purchases by Gender",
            xaxis = list(title = "Gender"),
            yaxis = list(title = "Total Purchase Amount (USD)")
          )
        return(fig)
      }
    }
    
    # Popular Payment Methods (Pie Chart)
    else if (input$analysis_option_customer == "Popular Payment Methods") {
      if ("Payment Method" %in% colnames(shop)) {
        payment_methods <- shop %>%
          group_by(`Payment Method`) %>%
          summarise(count = n())
        
        fig <- plot_ly(
          data = payment_methods,
          labels = ~`Payment Method`,
          values = ~count,
          type = 'pie'
        ) %>%
          layout(title = "Distribution of Payment Methods Used")
        
        return(fig)
      }
    }
    
    # Age and Product Categories (Bar Chart)
    else if (input$analysis_option_customer == "Age and Product Categories") {
      if ("Age" %in% colnames(shop) && "Category" %in% colnames(shop)) {
        age_category <- shop %>%
          group_by(Age, Category) %>%
          summarise(count = n(), .groups = 'drop')
        
        fig <- plot_ly(
          data = age_category,
          x = ~Age,
          y = ~count,
          color = ~Category,
          type = 'bar'
        ) %>%
          layout(
            title = "Age and Product Categories",
            xaxis = list(title = "Age"),
            yaxis = list(title = "Number of Purchases"),
            barmode = "stack"
          )
        
        return(fig)
      }
    }
  })
  
  #store operations
  
  # Render selected analysis title
  output$analysis_title_store <- renderText({
    input$analysis_option_store
  })
  
  # Render Plotly visualization for store operations analysis
  output$analysis_plot_store <- renderPlotly({
    req(input$analysis_option_store)  # Ensure an option is selected
    
    # Purchase Behavior by Location (Bar Chart)
    if (input$analysis_option_store == "Purchase Behavior by Location") {
      if ("Location" %in% colnames(shop) && "Purchase Amount (USD)" %in% colnames(shop)) {
        location_behavior <- shop %>%
          group_by(Location) %>%
          summarise(total_spent = sum(`Purchase Amount (USD)`, na.rm = TRUE), .groups = 'drop') %>%
          arrange(desc(total_spent))
        
        fig <- plot_ly(
          data = location_behavior,
          x = ~Location,
          y = ~total_spent,
          type = 'bar'
        ) %>%
          layout(
            title = "Total Purchase Amount by Location",
            xaxis = list(title = "Location"),
            yaxis = list(title = "Total Purchase Amount (USD)"),
            barmode = "group"
          )
        
        return(fig)
      }
    }
    
    # Age and Product Categories (Heatmap)
    else if (input$analysis_option_store == "Age and Product Categories") {
      if ("Age" %in% colnames(shop) && "Category" %in% colnames(shop)) {
        age_category <- shop %>%
          group_by(Age, Category) %>%
          summarise(count = n(), .groups = 'drop')
        
        fig <- plot_ly(
          data = age_category,
          x = ~Category,
          y = ~Age,
          z = ~count,
          type = "heatmap",
          colorscale = "Blues"
        ) %>%
          layout(
            title = "Customer Age Distribution Across Product Categories",
            xaxis = list(title = "Product Category"),
            yaxis = list(title = "Age Group")
          )
        
        return(fig)
      }
    }
  })
  
  
  #map
  output$leaflet <- renderLeaflet({
    leaflet(location_data) %>%
      addTiles() %>%
      addMarkers(~lng, ~lat, popup = ~paste(Location, "<br>", "Total Purchase Amount: $", Total_Purchase_Amount)) %>%
      setView(lng = mean(location_data$lng), lat = mean(location_data$lat), zoom = 4)
  })
  
  #viewdataset
  output$data_table <- renderDT({
    datatable(shop, options = list(pageLength = 10, scrollX = TRUE))
  })
  
  output$download_pdf <- downloadHandler(
    filename = function() {
      "BDA report.pdf"
    },
    content = function(file) {
      file.copy("BDA report.pdf", file)
    },
    contentType = "application/pdf"
  )
}

# Run the application
shinyApp(ui = ui, server = server)
