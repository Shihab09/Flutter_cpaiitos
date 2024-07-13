class UrlConstants {
  //base url
  String baseUrl = "http://cpatos.gov.bd/tosapi/pilot/v03212023/live/";

  //pilotageLandingpage total count api
  String TOTALCOUNTAPI() => baseUrl + "get_summery.php";
  String DATEWISEDATAAPI() => baseUrl + "get_report.php";
  //String TOTALCOUNTAPI()=>"https://jsonplaceholder.typicode.com/albums/1";
  String GETVESSELREPORTSPI() =>
      "http://cpatos.gov.bd/PcsOracle/index.php/pilotageApp/ReportController/Report";
}
