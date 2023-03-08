library MyApp.globals;

bool isLoggedIn = false;
var loggedUser = "";
var facility = "";
var mflcode = "";
var chw = "";
bool healthWorker = false;
bool CU = false;
// var ip = "192.168.3.128";
// var url = "http://" + ip + "/mpower_achap/data/getDataFunctions.php?task=";
// var ip = "52.255.177.11";
// var url ="http://" + ip + ":8089/mpower_achap/data/getDatafunctions.php?task=";

var ip = "197.232.14.151";
var url =
    "http://" + ip + ":8089/mpower_achap/data/getDataFunctions.php?task=";

//Defaulters
var clientID = "";
var names = "";
var dob = "";
var sex = "";
var serviceDefaulted = "";
var village = "";
var guardian = "";
var contacts = "";
var chvName = "";
var dateRegistered = "";
var contacted = "";
var reasonNotContacted = "";
var isDefaulter = "";
var serviceLocation = "";
var serviceDate = "";
var referTo = "";
var dateContacted = "";
// var mohserialno="";

//****** Household Mapping
var mothersName="";
var chuName="";
var hhNo="";
var yearBirth="";
var delivered="";
var dateDelivered="";
var deliveryPlace="";
var gender="";
var weightAtBirth="";
var supportGroup="";
var married="";
var spouseName;
var spouseContact="";
var otherName="";
var otherContact="";

int immunization = 0;
int vitaminA = 0;
int dewarming = 0;
int growthMonitoring = 0;
int anc = 0;
var phone = "";

///*************Awareness Objects********///
var diabetesObj = {
  "dbt1": "Understanding diabetes",
  "dbt2": "Risk factors for diabetes",
  "dbt3": "Signs and symptoms of diabetes",
  "dbt4": "Prevention of diabetes",
  "dbt5": "Healthy diet",
  "dbt6": "Physical activity",
  "dbt7": "How to manage diabetes",
  "dbt8": "Complications of diabetes",
  "dbt9": "Procedure for blood glucose testing",
  "dbt10": "Myths and Misconceptions of diabetes",
};

var hypertensionObj = {
  "bp1": "Understanding hypertension",
  "bp2": "Risk factors for hypertension",
  "bp3": "Signs and symptoms of hypertension",
  "bp4": "Understanding BP readings",
  "bp5": "Controlling high blood pressure",
  "bp6": "Healthy diet",
  "bp7": "Physical activity",
  "bp8": "Treatment of high blood pressure",
  "bp9": "Complications of high blood pressure",
  "bp10": "Side effects of blood pressure medication",
};

//$$2021Tekelezi