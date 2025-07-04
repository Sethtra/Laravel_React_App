import React from 'react'


function header() {
  return (
    <div>
      <>
        <meta charSet="utf-8" />
        <meta
          name="viewport"
          content="width=device-width, initial-scale=1, shrink-to-fit=no"
        />
        <link
          rel="apple-touch-icon"
          sizes="76x76"
          href="../assets/img/apple-icon.png"
        />
        <link rel="icon" type="image/png" href="../assets/img/favicon.png" />
        <title>Material Dashboard 3 by Creative Tim</title>
        {/*     Fonts and icons     */}
        <link
          rel="stylesheet"
          type="text/css"
          href="https://fonts.googleapis.com/css?family=Inter:300,400,500,600,700,900"
        />
        {/* Nucleo Icons */}
        <link href="assets/css/nucleo-icons.css" rel="stylesheet" />
        <link href="assets/css/nucleo-svg.css" rel="stylesheet" />
        {/* Font Awesome Icons */}
        {/* Material Icons */}
        <link
          rel="stylesheet"
          href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,400,0,0"
        />
        {/* CSS Files */}
        <link
          id="pagestyle"
          href="../../assets/css/material-dashboard.css?v=3.2.0"
          rel="stylesheet"
        />
      </>
    </div>
  );
}

export default header