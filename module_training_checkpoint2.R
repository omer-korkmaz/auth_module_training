# BUSINESS SCIENCE ----
# DS4B 202-R ----
# AUTHENTICATION & MODULE TRAINING -----
# Version 1

# APPLICATION DESCRIPTION ----
# - Render a Login Dialog Page
# - Dynamically render a UI upon authentication
# - Create a module to produce the login
# - Use the shinyauthr package

library(shiny)
library(shinythemes)
library(shinyjs)
library(tidyverse)

library(shinyauthr) # devtools::install_github("business-science/shinyauthr")


source("modules/module_login.R")

ui <- navbarPage(
    title = "Module Training", 
    theme = shinytheme("flatly"),
    collapsible = TRUE,
    
    tabPanel(
        useShinyjs(),
        title = "Login Module",
        
        h2("No Module"),
        
        div(
            id = "login",
            style = "width: 500px; max-width: 100%; margin: 0 auto; padding: 20px;",
            div(
                class = "well",
                h2(class = "text-center", "Please Login"),
                
                textInput(inputId     = "user_name", 
                          label       = tagList(icon("user"), "User Name"), 
                          placeholder = "Enter user name"),
                
                passwordInput(inputId      = "password",
                              label       = tagList(icon("unlock-alt"), "Password"),
                              placeholder = "Enter password"),
                
                div(
                    class = "text-center",
                    actionButton(inputId = "login_button", "Log in", class = "btn-primary", style = "color:white;")
                )
            )
        ),
        
        uiOutput(outputId = "display_content"),
        
        h2("Using A Module"),
        
        login_ui(id = "login_2", "Modular Login"),
        
        uiOutput(outputId = "display_content_2"),
        
        h2('Using Shiny Auth')
        
        # TODO
    )
)

server <- function(input, output, session) {
    
    user_base_tbl <- tibble(
        user_name = "user1",
        password  = "pass1"
    )
    
    # NO MODULE ----
    validate_password <- eventReactive(input$login_button, {
        
        validate <- FALSE
        if (input$user_name == user_base_tbl$user_name && input$password == user_base_tbl$password) {
            validate <- TRUE
        }
        
        validate
        
    })
    
    output$display_content <- renderUI({
        
        req(validate_password())
        
        div(
            class = "well",
            id = "success",
            h1(class = "page-header", "Stock Analyer", tags$small("by Business Science")),
            p(class = "lead", "Page content...")
        )
        
    })
    
    
    # MODULE ----
    validate_2 <- callModule(
        module   = validate_pwd, 
        id       = "login_2", 
        data     = user_base_tbl,
        user_col = user_name, 
        pwd_col  = password)
    
    output$display_content_2 <- renderUI({
        
        req(validate_2())
        
        div(
            class = "well",
            id = "success",
            h1(class = "page-header", "Stock Analyer (VALIDATE MODULE)", tags$small("by Business Science")),
            p(class = "lead", "Page content...")
        )
        
    })
    
    # SHINYAUTHR ----
    
    
}

shinyApp(ui, server)