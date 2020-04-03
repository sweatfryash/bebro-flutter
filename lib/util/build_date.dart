//构建日期
String buildDate(String date) {
  var now = DateTime.now();
  var dateTime = DateTime.parse(date);
  var yesterday = DateTime(now.year, now.month, now.day-1, 23, 59, 59);
  var beforeYesterday = DateTime(now.year, now.month, now.day-2, 23, 59, 59);
  var minutes = now.difference(dateTime).inMinutes;
  if(minutes == 0){
    return '刚刚';
  } else if(minutes < 60){
    return '$minutes分钟前';
  }else if(dateTime.isAfter(yesterday)){
    return '今天${date.substring(date.length-9,date.length-3)}';
  }else if(dateTime.isAfter(beforeYesterday)){
    return '昨天${date.substring(date.length-9,date.length-3)}';
  }else if(dateTime.year < now.year){
    return date.substring(0,date.length-3);
  }else{
    return date.substring(5,date.length-3);
  }
}