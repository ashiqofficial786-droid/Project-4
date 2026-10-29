*** Settings ***
Documentation     Test Cases 1-4 for https://www.saucedemo.com/
...               Run all:  robot -d results tests/
Resource          ../resources/keywords.resource
Test Setup        Open SauceDemo
Test Teardown     Close SauceDemo

*** Test Cases ***
TC01 Login With Valid Credentials Lands On Products Page
    [Documentation]    Login with standard_user / secret_sauce and verify the Products page.
    [Tags]    login    smoke    tc01
    Login With Valid Credentials
    Verify User Is On Products Page

TC02 Login With Invalid Credentials Shows Error Message
    [Documentation]    Login with wrong credentials and verify the error message appears.
    [Tags]    login    negative    tc02
    Login With Invalid Credentials
    Verify Login Error Message

TC03 Add Product To Cart And Verify It Is Listed In Cart
    [Documentation]    After valid login, add one product and verify it appears in the cart.
    [Tags]    cart    tc03
    Login And Verify Products Page
    Add Product To Cart    ${PRODUCT_1_BUTTON}
    Verify Cart Badge Count    1
    Open Cart
    Verify Product Is In Cart    ${PRODUCT_1_NAME}
    Verify Cart Has Item Count    1

TC04 Add Multiple Products And Verify Checkout Summary
    [Documentation]    Add several products, go to checkout and verify that the
    ...                correct items and quantities appear in the checkout summary.
    [Tags]    checkout    tc04
    Login And Verify Products Page
    Add Product To Cart    ${PRODUCT_1_BUTTON}
    Add Product To Cart    ${PRODUCT_2_BUTTON}
    Add Product To Cart    ${PRODUCT_3_BUTTON}
    Verify Cart Badge Count    3
    Open Cart
    Proceed To Checkout
    Fill Checkout Information
    @{expected}=    Create List    ${PRODUCT_1_NAME}    ${PRODUCT_2_NAME}    ${PRODUCT_3_NAME}
    Verify Checkout Summary Contains    ${expected}
