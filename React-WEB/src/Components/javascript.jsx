import React, { useEffect } from "react";
import { Helmet } from "react-helmet";

const JavaScript = () => {
  useEffect(() => {
    const addScript = (src, async = true) => {
      const script = document.createElement("script");
      script.src = src;
      script.async = async;
      document.head.appendChild(script);
      return script;
    };

    const scriptJQuery = addScript("/assets/js/jquery.min.js");

    scriptJQuery.onload = () => {
      const scriptJQueryMigrate = addScript(
        "/assets/js/jquery-migrate-3.0.1.min.js"
      );

      scriptJQueryMigrate.onload = () => {
        addScript("/assets/js/popper.min.js");
        addScript("/assets/js/bootstrap.min.js");
        addScript("/assets/js/jquery.easing.1.3.js");
        addScript("/assets/js/jquery.waypoints.min.js");
        addScript("/assets/js/jquery.stellar.min.js").onload = () => {
          addScript("/assets/js/owl.carousel.min.js");
          addScript("/assets/js/jquery.magnific-popup.min.js");
          addScript("/assets/js/aos.js");
          addScript("/assets/js/jquery.animateNumber.min.js");
          addScript("/assets/js/bootstrap-datepicker.js");
          addScript("/assets/js/scrollax.min.js");

          // Google Maps + custom scripts
          addScript(
            "https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&sensor=false"
          );
          addScript("/assets/js/google-map.js");
          addScript("/assets/js/main.js");
        };
      };
    };

    // Optional: clean up scripts when the component unmounts
    return () => {
      document.head
        .querySelectorAll(
          "script[src*='/assets/js/'], script[src*='maps.googleapis.com']"
        )
        .forEach((script) => script.remove());
    };
  }, []);

  return <Helmet>{/* Optional meta tags or title */}</Helmet>;
};

export default JavaScript;