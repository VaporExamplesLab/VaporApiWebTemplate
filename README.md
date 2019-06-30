<p align="center">
    <img src="README_files/AWT.png" width="480" alt="API + Web Template">
    <br>
    <br>
    <a href="http://docs.vapor.codes/3.0/">
        <img src="http://img.shields.io/badge/read_the-docs-2196f3.svg" alt="Documentation">
    </a>
    <a href="LICENSE">
        <img src="http://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://swift.org">
        <img src="http://img.shields.io/badge/swift-4.2-brightgreen.svg" alt="Swift 4.2">
    </a>
</p>

> NOTE: After an Xcode update to Swift 4.2, `NIO`, `NIOFoundationCompat`, `NIOHTTP1`, and `NIOHTTP1` warnings can be silenced by setting the `SWIFT_VERSION` to "Swift 4" in the Target build settings. 

<a id=toc></a>
[Example Routes](#ExampleRoutes) • 
[Components](#Components) • 
[Use](#Use) • 
[Resources](#Resources)

`VaporApiWebTemplate` is an API + Web Template (AWT) hybrid based on [vapor/api-template](https://github.com/vapor/api-template) and [vapor/web-template](https://github.com/vapor/web-template).  `VaporApiWebTemplate` template uses Vapor 3, Swift 4.1 and Xcode 9.

`VaporApiWebTemplate` also includes a set of lightweight examples: 

* api routes which use SQLite (`TextpostApiController`, `Textpost`)
* web page routes which serve static files from "Public/" (`FileMiddleware` enabled)
* web page routes which use Leaf templating (`LeafWebController`)
* simple custom `Middleware` (`ExampleMiddleware`)
* simple custom `Service` (`ExampleService`, `ExampleFortuneService`, `ExampleQuoteService`, `ExampleServiceProvider`)
* UUID extension for RFC 4122 compliance
* `XCTest` unit test examples

## Example Routes <a id="ExampleRoutes"></a>[▴](#toc)

Example routes setup in the baseline template.

**Basic**

`http://localhost:8080/hello`

```
Hello, world!
```  

`http://localhost:8080/hellojson`  

``` JSON
{"hello":"world"}
```

`http://localhost:8080/info`  

Returns a description of http request.

``` http
GET /api/info HTTP/1.1
Host: localhost:8080
Accept: */*
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Connection: keep-alive
User-Agent: …
<no body>
```

**Dynamic API (Fluent)**

* `/api/textposts` POST creates one database entry for valid JSON `Textpost`.
* `/api/textposts` GET returns an array of all available `Textpost`
* `/api/textposts/uuid` GET returns one specific `Textpost`
* `/api/textposts` PUT updates an existing `Textpost` or create a new `Textpost`. 
* `/api/textposts/uuid` PATCH applies partial update modification to specific `Textpost` entry.
* `/api/textposts/uuid` DELETE removes one specific `Textpost`.

**Static HTML**

* `http://localhost:8080/` redirects to '/index.html'.
* `http://localhost:8080/index.html` minimal HTML 5.

**Web HTML Templates (Leaf)**

* `http://localhost:8080/leaf` simple leaf example.  
* `http://localhost:8080/leaf/hello`
* `http://localhost:8080/leaf/hello/Sunshine` leaf with a `String` parameter.


``` markup
<!DOCTYPE html>
<html>
<head>
	<title>Hello, Sunshine!</title>
	<link rel="stylesheet" href="/styles/app.css">
</head>
<body>
<h1>Hello, Sunshine!</h1>
</body>
</html>
```

* `http://localhost:8080/leaf/bootstrap` example page with Bootstrap, Swift data objects and Leaf. 

## Components  <a id="Components"></a>[▴](#toc)

### API Fluent

```
Sources/App/
  Controllers/
    TextpostController.swift
  Models/
    Textpost.swift
Tests/AppTests/
  TextpostControllerTests.swift
```

### Web Leaf Template

Leaf templating components.

```
Sources/App/
  Controllers/
    LeafWebController.swift
  Public/
    images/it-works.png
    scripts/.gitkeep
    styles/app.css
  Resources/
    Views/
      bootstrap_web.leaf
      bootstrap_welcome.leaf
      web_base.leaf
      web_hello.leaf
Tests/AppTests/
  LeafWebControllerTests.swift
```

## Use <a id="Use"></a>[▴](#toc)

``` bash
vapor new PROJECT_NAME --template=marc-medley/004.77_VaporApiWebTemplate
cd PROJECT_NAME
vapor update
```

Set the Xcode active scheme to `Run > My Mac`.

![](README_files/XcodeSchemeSetting.png)

## Resources <a id="Resources"></a>[▴](#toc)

[Atom: language-leaf ⇗](https://atom.io/packages/language-leaf)  
[Mac App Store: RESTed - Simple HTTP Requests ⇗](https://itunes.apple.com/us/app/rested-simple-http-requests/id421879749) _…free._


