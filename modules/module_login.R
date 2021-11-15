
# UI

login_ui <- function(id, title) {
    
    ns <- NS(id)
    
    div(
        id = ns("login"),
        style = "width: 500px; max-width: 100%; margin: 0 auto; padding: 20px;",
        div(
            class = "well",
            h2(class = "text-center", title),
            
            textInput(
                inputId = ns("user_name"),
                label = tagList(icon("user"), "User Name"),
                placeholder = "Enter User Name"
            ),
            
            passwordInput(
                inputId = ns("password"),
                label = tagList(icon("unlock-alt"), "Password"),
                placeholder = "Enter Password"
            ),
            
            div(
                class = "text-center",
                actionButton(
                    inputId = ns("login_button"),
                    "Log in",
                    class = "btn-primary",
                    style = "color:white;"
                )
            )
        )
    )
}

# SERVER

validate_pwd <- function(input, output, session, data, user_col, pwd_col) {
    
    user <- data %>% pull(!! enquo(user_col))
    pwd <- data %>% pull(!! enquo(pwd_col))
    
    eventReactive(input$login_button, {
        
        validate <- FALSE
        if (input$user_name == user && input$password == pwd) {
            validate <- TRUE
        }
        
        if(validate) shinyjs::hideElement(id = "login")
        
        validate
        
    })
}

