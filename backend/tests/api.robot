*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${API_URL}        http://proxy/articles/

*** Test Cases ***

Verify Get Articles Count
    [Documentation]    Pobranie listy artykułów dwukrotnie i sprawdzenie, że liczba artykułów się nie zmieniła
    ${response1}=    GET    ${API_URL}
    ${count1}=    Get Length    ${response1.json()}
    ${response2}=    GET    ${API_URL}
    ${count2}=    Get Length    ${response2.json()}
    Should Be Equal    ${count1}    ${count2}

Verify Add and Delete Article
    [Documentation]    Dodanie artykułu X, sprawdzenie czy jest na liście, a następnie usunięcie go.
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${data}=    Create Dictionary    title=Test Title    content=Test Content
    ${response}=    POST    ${API_URL}    json=${data}    headers=${headers}    expected_status=201

    ${articles}=    GET    ${API_URL}
    ${titles}=    Get Article Titles    ${articles.json()}
    List Should Contain Value    ${titles}    Test Title

    ${article_id}=    Get Article ID By Title    ${articles.json()}    Test Title
    DELETE    ${API_URL}${article_id}    expected_status=204

    ${articles}=    GET    ${API_URL}
    ${titles}=    Get Article Titles    ${articles.json()}
    List Should Not Contain Value    ${titles}    Test Title

Verify Delete Non-existent Article
    [Documentation]    Próba usunięcia nieistniejącego artykułu i sprawdzenie, że zwrócony został błąd 404
    DELETE    ${API_URL}99999    expected_status=404

Verify Add Article Without Title
    [Documentation]    Próba dodania artykułu bez tytułu i sprawdzenie, że zwrócony został błąd 400
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${data}=    Create Dictionary    content=Test Content
    ${response}=    POST    ${API_URL}    json=${data}    headers=${headers}    expected_status=400 

*** Test Cases ***
Verify Get Request
    ${response}=  GET  http://proxy/health  expected_status=200


Verify Post Request
    # ${response}=  POST  http://proxy/articles/  data={"title":"test","content":"test"}  expected_status=201

    ${headers}=  Create Dictionary  Content-Type=application/json
    ${response}=  POST  http://proxy/articles/  data={"title":"test","content":"test"}  headers=${headers}  expected_status=201
