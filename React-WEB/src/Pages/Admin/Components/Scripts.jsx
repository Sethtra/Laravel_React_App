import React, { useEffect } from "react";
import { Helmet } from "react-helmet";

const Scripts = () => {
  useEffect(() => {
    // Dynamically load external scripts after the component mounts
    const scriptUrls = [
      "/assets/js/core/popper.min.js",
      "/assets/js/core/bootstrap.min.js",
      "/assets/js/plugins/perfect-scrollbar.min.js",
      "/assets/js/plugins/smooth-scrollbar.min.js",
      "/assets/js/plugins/chartjs.min.js",
    ];

    // Add scripts dynamically to the head tag
    scriptUrls.forEach((src) => {
      const script = document.createElement("script");
      script.src = src;
      script.async = true;
      document.body.appendChild(script);
      return () => document.body.removeChild(script); // Clean up the script on unmount
    });

    // Inline chart-related script
    const chartScript = document.createElement("script");
    chartScript.text = `
      window.onload = function() {
        var ctx = document.getElementById("chart-bars").getContext("2d");
        new Chart(ctx, {
          type: "bar",
          data: {
            labels: ["M", "T", "W", "T", "F", "S", "S"],
            datasets: [{
              label: "Views",
              tension: 0.4,
              borderWidth: 0,
              borderRadius: 4,
              borderSkipped: false,
              backgroundColor: "#43A047",
              data: [50, 45, 22, 28, 50, 60, 76],
              barThickness: 'flex'
            }]
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
              legend: { display: false },
            },
            interaction: { intersect: false, mode: 'index' },
            scales: {
              y: {
                grid: {
                  drawBorder: false,
                  display: true,
                  color: '#e5e5e5'
                },
                ticks: {
                  suggestedMin: 0,
                  suggestedMax: 500,
                  beginAtZero: true,
                  padding: 10,
                  font: { size: 14, lineHeight: 2 },
                  color: "#737373"
                }
              },
              x: {
                grid: { drawBorder: false, display: false },
                ticks: {
                  display: true,
                  color: '#737373',
                  padding: 10,
                  font: { size: 14, lineHeight: 2 },
                }
              }
            }
          }
        });
      };
    `;
    document.body.appendChild(chartScript);

    return () => {
      document.body.removeChild(chartScript); // Clean up inline script
    };
  }, []);

  return (
    <Helmet>
      {/* Core JS Files */}
      <script src="/assets/js/core/popper.min.js" />
      <script src="/assets/js/core/bootstrap.min.js" />
      <script src="/assets/js/plugins/perfect-scrollbar.min.js" />
      <script src="/assets/js/plugins/smooth-scrollbar.min.js" />
      <script src="/assets/js/plugins/chartjs.min.js" />
      <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
      <script src="https://code.jquery.com/jquery-migrate-3.3.2.min.js"></script>
    </Helmet>
  );
};

export default Scripts;