import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    values: Array,
    labels: Array
  }

  connect() {
    var data = [{
      values: this.valuesValue,
      labels: this.labelsValue,
      domain: { x: [0, 1], y: [0, 1] },
      name: '',
      hoverinfo: 'label+percent',
      hole: .6,
      type: 'pie',
      textfont: {
        size: 14
      },
      rotation: 90,
      textinfo: 'none',
      marker: {
        colors: ['#2ca02c', '#ffb50e', '#d62728', "#4d80df"],
        line: {
          color: "#ffffff",
          width: 3,
        }
      },
      direction: 'clockwise',
      sort: false,
      insidetextfont: {
        size: 12,
      }
    }];

    var layout = {
      title: {
        text: '<span>Compliance Overview' +
          '<br><span style="color: #6a7282; font-size:14px; font-weight:normal; font-family: Open Sans, Arial, sans-serif;">' +
          'Track posture across standards and categories' +
          '</span></span>',
        x: 0.0175,
        xanchor: 'left',
        font: {
          size: 24,
          family: 'Georgia, Times New Roman, Times, serif',
          weight: 'bold',
          color: '#111111'
        }
      },
      annotations: [],
      height: 390,
      width: 430,
      responsive: true,
      showlegend: false,
      legend: {
        font: {
          size: 12
        }
      },
      grid: { rows: 1, columns: 2 }
    };

    Plotly.newPlot(this.element, data, layout, { responsive: true });
  }
}

