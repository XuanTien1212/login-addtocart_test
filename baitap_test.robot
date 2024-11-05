*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BROWSER}             chrome
${URL}                 https://fado.vn/dang-nhap?redirect=https%3A%2F%2Ffado.vn%2F
${USERNAME}            doxuantien121203@gmail.com   # Thay bằng username của bạn
${PASSWORD}            Truonglucky123               # Thay bằng password của bạn
${PRODUCT_NAME}        dong ho                      # Sản phẩm muốn tìm kiếm
${QUANTITY}            2                            # Số lượng sản phẩm

# Định nghĩa các XPath và CSS Selector
${LOGIN_BUTTON}        xpath=//button[contains(text(),'Đăng nhập')]
${USERNAME_FIELD}      xpath=//input[@type='email']
${PASSWORD_FIELD}      xpath=//input[@type='password']
${SEARCH_INPUT}        xpath=//html/body/section[1]/div[2]/div/div/div[2]/div/div/div[2]/input
${FIRST_PRODUCT}       xpath=(//div[contains(@class, 'product-card-col')])[1]
#${QUANTITY_INPUT_CHECK}      xpath=//div[@class='quantity-control-group']
${QUANTITY_INPUT}      xpath=//div[@class='f23-product-detail-info-row cart-segment ']//input[@class='quantity-input']
${ADD_TO_CART_BTN}     xpath=//button[contains(@class, 'add-cart-btn') and .//span[contains(text(), 'Thêm vào giỏ hàng')]]
#${CART_ICON}           xpath=//a[contains(@class, 'cart-icon')]
#${CART_QUANTITY}       xpath=//input[contains(@class, 'cart-quantity')]
#${CART_TOTAL_PRICE}    xpath=//span[contains(@class, 'cart-total-price')]
#${QUANTITY_INPUT}      xpath=//html/body/div[1]/div/div/div[1]/section[1]/div[1]/div[2]/div[12]/div/input
#${ADD_TO_CART_BTN}     xpath=//html/body/div[1]/div/div/div[1]/section[1]/div[1]/div[2]/div[12]/button
${CART_ICON}           xpath=//html/body/section[1]/div[2]/div/div/div[3]/div/a/div[1]
${CART_QUANTITY}       xpath=//input[contains(@class, 'mz-number-control__input')]
${CART_TOTAL_PRICE}    xpath=//html/body/div[1]/div/div/section/div/div/div[2]/div/div/div[2]/div/div[3]/div/span
${SEARCH_BUTTON}       xpath=//html/body/section[1]/div[2]/div/div/div[2]/div/button

*** Test Cases ***
Login and Add Product to Cart
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window

    # Đăng nhập vào tài khoản
    Input Text       ${USERNAME_FIELD}    ${USERNAME}
    Input Text       ${PASSWORD_FIELD}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
    Wait Until Page Contains Element    xpath=//a[contains(text(),'Đỗ Xuân Tiến')]    timeout=10s

    # Tìm kiếm và chọn sản phẩm
    Input Text       ${SEARCH_INPUT}    ${PRODUCT_NAME}
    Press Keys        ${SEARCH_INPUT}    ENTER
    Wait Until Page Contains Element    ${FIRST_PRODUCT}    timeout=10s
    Click Element    ${FIRST_PRODUCT}
    Execute JavaScript    window.scrollBy(0, 500)   # Cuộn xuống 500 pixel

    # Cuộn đến phần tử và thiết lập số lượng
    Wait Until Page Contains Element    ${QUANTITY_INPUT}    timeout=5s
    Click Element    ${QUANTITY_INPUT}
    Sleep    1s
    Press Keys       ${QUANTITY_INPUT}    DELETE  # Xóa giá trị hiện tại
    Input Text       ${QUANTITY_INPUT}    ${QUANTITY}
    Click Element    ${ADD_TO_CART_BTN}
    Sleep    2s

    # Kiểm tra giỏ hàng
    Wait Until Element Is Visible    xpath=//div[contains(text(),'Đã thêm sản phẩm vào giỏ hàng thành công!')]    timeout=10s
    Click Element    xpath=//a[contains(@class, 'mz-btn') and contains(text(), 'Xem giỏ hàng và thanh toán')]

    # Kiểm tra số lượng và giá
    ${cart_quantity}=    Get Value    ${CART_QUANTITY}
    ${price}=            Get Text     ${CART_TOTAL_PRICE}

    # In ra thông tin
    Log To Console    Số lượng sản phẩm trong giỏ hàng: ${cart_quantity}
    Log To Console    Tổng giá: ${price}

    # Đóng trình duyệt
    Close Browser
