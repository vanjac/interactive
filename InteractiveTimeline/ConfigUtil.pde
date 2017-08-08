final String[] MONTHS = {
  "Jan.",
  "Feb.",
  "Mar.",
  "Apr.",
  "May",
  "June",
  "July",
  "Aug.",
  "Sep.",
  "Oct.",
  "Nov.",
  "Dec."
};

void addDot(int year, int month, int day, String subTitle) {
  float t = getTime(year, month, day);
  String title = getDateName(year, month, day);
  
  TimelineDot d = new TimelineDot(t, title, subTitle);
  addTimelineDot(d);
}

void addTextDot(int year, int month, int day, String subTitle, String content) {
  float t = getTime(year, month, day);
  String title = getDateName(year, month, day);
  
  TimelineDot d = new TextDot(t, title, subTitle, content);
  addTimelineDot(d);
}

void addImageDot(int year, int month, int day,
    String subTitle, String content, String imageFile) {
  float t = getTime(year, month, day);
  String title = getDateName(year, month, day);
  PImage image = loadImage(imageFile);
  
  TimelineDot d = new TextImageDot(t, title, subTitle, content, image);
  addTimelineDot(d);
}

float getTime(int year, int month, int day) {
  if(month == 0)
    month = 6;
  if(day == 0)
    day = 15;
  
  return year - ORIGIN_YEAR + (float(month)) / 12.0 + (float(day)) / 365.0;
}

String getDateName(int year, int month, int day) {
  String title = str(year);
  if(month > 0) {
    String monthName = MONTHS[month - 1];
    if(day > 0) {
      title = monthName + " " + str(day) + ", " + title;
    } else {
      title = monthName + " " + title;
    }
  }
  
  return title;
}