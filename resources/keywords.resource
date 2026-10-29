*** Settings ***
Documentation     Reusable keywords for the SauceDemo automation framework.
...               Test suites only call these keywords, so UI locators and
...               low-level actions live in a single place (keyword-driven testing).
Library           SeleniumLibrary    timeout=10s
Library           BuiltIn
Library           Collections
Resource          variables.resource

*** Variables ***
# ---------- Locators ----------
${LOC_USERNAME}           id=user-name
${LOC_PASSWORD}           id=password
${LOC_LOGIN_BUTTON}       id=login-button
${LOC_ERROR}              css=[data-test="error"]
${LOC_PAGE_TITLE}         css=.title
${LOC_CART_LINK}          css=.shopping_cart_link
${LOC_CART_BADGE}         css=.shopping_cart_badge
${LOC_CART_ITEM_NAME}     css=.cart_item .inventory_item_name
${LOC_CART_ITEM}          css=.cart_item
${LOC_CART_QTY}           css=.cart_quantity
${LOC_CHECKOUT_BUTTON}    id=checkout
${LOC_FIRST_NAME}         id=first-name
${LOC_LAST_NAME}          id=last-name
${LOC_POSTAL_CODE}        id=postal-code
${LOC_CONTINUE_BUTTON}    id=continue

*** Keywords ***
# =====================================================================
# Browser / session keywords
# =====================================================================
Open SauceDemo
    [Documentation]    Opens the browser on the SauceDemo login page.
    ...                Uses headless Chrome when ${HEADLESS} is True (useful for CI).
    # Chrome options: disable password-manager popups that can block clicks.
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --disable-notifications
    Call Method    ${options}    add_argument    --window-size\=1366,768
    Call Method    ${options}    add_argument    --disable-search-engine-choice-screen
    ${prefs}=    Create Dictionary
    ...    credentials_enable_service=${FALSE}
    ...    profile.password_manager_enabled=${FALSE}
    ...    profile.password_manager_leak_detection=${FALSE}
    Call Method    ${options}    add_experimental_option    prefs    ${prefs}
    IF    ${HEADLESS}
        Call Method    ${options}    add_argument    --headless\=new
    END
    Open Browser    ${BASE_URL}    ${BROWSER}    options=${options}
    Maximize Browser Window
    Wait Until Element Is Visible    ${LOC_LOGIN_BUTTON}

Close SauceDemo
    [Documentation]    Closes every browser opened by the test (teardown helper).
    Close All Browsers

# =====================================================================
# Login keywords
# =====================================================================
Login With Credentials
    [Documentation]    Types the given username/password and clicks Login.
    [Arguments]    ${username}    ${password}
    Wait Until Element Is Visible    ${LOC_USERNAME}
    Input Text        ${LOC_USERNAME}    ${username}
    Input Password    ${LOC_PASSWORD}    ${password}
    Click Button      ${LOC_LOGIN_BUTTON}

Login With Valid Credentials
    [Documentation]    Logs in using the standard (valid) user from variables.resource.
    Login With Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}

Login With Invalid Credentials
    [Documentation]    Attempts login with the invalid user from variables.resource.
    Login With Credentials    ${INVALID_USERNAME}    ${INVALID_PASSWORD}

Verify User Is On Products Page
    [Documentation]    Passes only if the URL is the inventory page and the
    ...                page header reads "Products".
    Wait Until Location Contains    inventory.html
    Element Text Should Be    ${LOC_PAGE_TITLE}    ${PRODUCTS_PAGE_TITLE}

Verify Login Error Message
    [Documentation]    Checks that the error banner is shown with the expected text
    ...                and that the user was NOT taken to the products page.
    [Arguments]    ${expected_message}=${LOGIN_ERROR_MESSAGE}
    Wait Until Element Is Visible    ${LOC_ERROR}
    Element Text Should Be    ${LOC_ERROR}    ${expected_message}
    Location Should Be    ${BASE_URL}

Login And Verify Products Page
    [Documentation]    Convenience keyword used by the cart/checkout tests as a precondition.
    Login With Valid Credentials
    Verify User Is On Products Page

# =====================================================================
# Cart keywords
# =====================================================================
Add Product To Cart
    [Documentation]    Clicks the "Add to cart" button of a product.
    ...                ${button_locator} - locator of that product's add button.
    [Arguments]    ${button_locator}
    Wait Until Element Is Visible    ${button_locator}
    Click Button    ${button_locator}

Verify Cart Badge Count
    [Documentation]    Verifies the number shown on the cart icon.
    [Arguments]    ${expected_count}
    Element Text Should Be    ${LOC_CART_BADGE}    ${expected_count}

Open Cart
    [Documentation]    Clicks the cart icon and waits for the cart page.
    Click Element    ${LOC_CART_LINK}
    Wait Until Location Contains    cart.html

Get Cart Item Names
    [Documentation]    Returns a list with the names of all products currently in the cart.
    ${elements}=    Get WebElements    ${LOC_CART_ITEM_NAME}
    ${names}=       Create List
    FOR    ${element}    IN    @{elements}
        ${text}=    Get Text    ${element}
        Append To List    ${names}    ${text}
    END
    RETURN    ${names}

Verify Product Is In Cart
    [Documentation]    Fails if the product name is not listed on the cart page.
    [Arguments]    ${product_name}
    ${names}=    Get Cart Item Names
    List Should Contain Value    ${names}    ${product_name}
    ...    msg=Product '${product_name}' was not found in the cart. Cart has: ${names}

Verify Cart Has Item Count
    [Documentation]    Verifies how many distinct line items are in the cart.
    [Arguments]    ${expected_count}
    ${count}=    Get Element Count    ${LOC_CART_ITEM}
    Should Be Equal As Integers    ${count}    ${expected_count}

Verify Each Item Quantity Is One
    [Documentation]    Every line item added from the products page has quantity 1.
    ${quantities}=    Get WebElements    ${LOC_CART_QTY}
    FOR    ${qty}    IN    @{quantities}
        Element Text Should Be    ${qty}    1
    END

# =====================================================================
# Checkout keywords
# =====================================================================
Proceed To Checkout
    [Documentation]    Clicks Checkout on the cart page.
    Click Button    ${LOC_CHECKOUT_BUTTON}
    Wait Until Location Contains    checkout-step-one.html

Fill Checkout Information
    [Documentation]    Fills the customer form and continues to the overview (summary) page.
    [Arguments]    ${first}=${FIRST_NAME}    ${last}=${LAST_NAME}    ${postal}=${POSTAL_CODE}
    Input Text      ${LOC_FIRST_NAME}     ${first}
    Input Text      ${LOC_LAST_NAME}      ${last}
    Input Text      ${LOC_POSTAL_CODE}    ${postal}
    Click Button    ${LOC_CONTINUE_BUTTON}
    Wait Until Location Contains    checkout-step-two.html
    Element Text Should Be    ${LOC_PAGE_TITLE}    ${CHECKOUT_TITLE}

Verify Checkout Summary Contains
    [Documentation]    Verifies the checkout summary lists exactly the expected items,
    ...                each with quantity 1.
    ...                ${expected_names} - list of product names expected in the summary.
    [Arguments]    ${expected_names}
    ${expected_count}=    Get Length    ${expected_names}
    Verify Cart Has Item Count    ${expected_count}
    ${actual_names}=    Get Cart Item Names
    Lists Should Be Equal    ${actual_names}    ${expected_names}    ignore_order=True
    Verify Each Item Quantity Is One
