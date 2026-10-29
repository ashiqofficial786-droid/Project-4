# SauceDemo – Robot Framework Automation (Task 20)

Keyword-driven UI test automation for <https://www.saucedemo.com/> using
**Robot Framework**, **SeleniumLibrary** and **BuiltIn**.

## Project structure

```
saucedemo-robot-framework/
├── resources/
│   ├── variables.resource   # URL, credentials, products, expected messages
│   └── keywords.resource    # reusable, commented keywords (locators live here)
├── tests/
│   └── saucedemo_tests.robot   # TC01 – TC04
├── requirements.txt
├── .gitignore
└── README.md
```

## Test cases

| ID   | Description |
|------|-------------|
| TC01 | Login with `standard_user` / `secret_sauce` → lands on Products page |
| TC02 | Login with invalid credentials → error message displayed |
| TC03 | Login, add a product → product is listed in the cart |
| TC04 | Login, add multiple products, go to checkout → correct items & quantities in summary |

## Setup

Prerequisites: Python 3.9+ and Google Chrome (Selenium 4 downloads the driver automatically).

```bash
python -m venv .venv
# Windows:  .venv\Scripts\activate
# macOS/Linux: source .venv/bin/activate
pip install -r requirements.txt
```

## Run

```bash
# all tests (reports go to results/)
robot -d results tests/

# a single test by tag
robot -d results -i tc01 tests/

# headless / other browser
robot -d results -v HEADLESS:True tests/
robot -d results -v BROWSER:firefox tests/
```

Open `results/report.html` and `results/log.html` after the run.
