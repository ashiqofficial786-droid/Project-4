*** Settings ***
Documentation     Central place for all reusable test data: URLs, credentials,
...               products and expected messages.

*** Variables ***
# ---------- Application / browser ----------
${BASE_URL}               https://www.saucedemo.com/
${BROWSER}                chrome
${HEADLESS}               ${FALSE}        # set to ${TRUE} on CI machines (-v HEADLESS:True)
${TIMEOUT}                10s

# ---------- Credentials ----------
${VALID_USERNAME}         standard_user
${VALID_PASSWORD}         secret_sauce
${INVALID_USERNAME}       invalid_user
${INVALID_PASSWORD}       wrong_password

# ---------- Checkout details ----------
${FIRST_NAME}             Test
${LAST_NAME}              User
${POSTAL_CODE}            600001

# ---------- Products (display name | element id of its "Add to cart" button) ----------
${PRODUCT_1_NAME}         Sauce Labs Backpack
${PRODUCT_1_BUTTON}       id=add-to-cart-sauce-labs-backpack
${PRODUCT_2_NAME}         Sauce Labs Bike Light
${PRODUCT_2_BUTTON}       id=add-to-cart-sauce-labs-bike-light
${PRODUCT_3_NAME}         Sauce Labs Bolt T-Shirt
${PRODUCT_3_BUTTON}       id=add-to-cart-sauce-labs-bolt-t-shirt

# ---------- Expected messages ----------
${PRODUCTS_PAGE_TITLE}    Products
${LOGIN_ERROR_MESSAGE}    Epic sadface: Username and password do not match any user in this service
${CHECKOUT_TITLE}         Checkout: Overview
