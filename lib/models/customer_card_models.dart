class CustomerItemModel {
  String name;
  int id;
  String contactNumber;
  String adrress;

  CustomerItemModel(this.name,this.id, this.contactNumber,this.adrress);
  
}

class CustomerHelper {
 static var chatList = [
  CustomerItemModel("Taylor Schuppe", 0, "0301-4567890", "House #23, Street 4, Karachi"),
  CustomerItemModel("Pedro Klocko DDS", 1, "0321-9876543", "Block A, DHA, Lahore"),
  CustomerItemModel("مولی ڈینیئل", 2, "0333-1122334", "فلیٹ نمبر 12، گلشنِ اقبال، کراچی"),
  CustomerItemModel("Lila Dooley", 3, "0300-7788990", "House #45, Bahria Town, Islamabad"),
  CustomerItemModel("کولین ٹرکوٹ", 4, "0345-6655443", "گلی نمبر 7، ماڈل ٹاؤن، لاہور"),
  CustomerItemModel("Pedro Klocko DDS", 5, "0312-9988776", "Shop #5, Saddar, Karachi"),
  CustomerItemModel("Molly Daniel", 6, "0306-1122112", "Block C, Clifton, Karachi"),
  CustomerItemModel("لیلا ڈولی", 7, "0324-3344556", "گلی نمبر 9، جوہر ٹاؤن، لاہور"),
  CustomerItemModel("Taylor Schuppe", 8, "0344-7788991", "Flat #33, PECHS, Karachi"),
  CustomerItemModel("لیلا ڈولی", 9, "0308-2233445", "گھر نمبر 67، ایف-10، اسلام آباد"),
  CustomerItemModel("Colleen Turcotte", 10, "0315-9988775", "Street 15, Gulberg, Lahore"),
  CustomerItemModel("پیڈرو کلاککو ڈی ڈی ایس", 11, "0323-1122446", "آفس نمبر 12، بلیو ایریا، اسلام آباد"),
  CustomerItemModel("Molly Daniel", 12, "0331-3344552", "Street 5, Garden Town, Lahore"),
  CustomerItemModel("لیلا ڈولی", 13, "0307-5566778", "فلیٹ نمبر 5، صدر، راولپنڈی"),
];
  static CustomerItemModel getchatitem(int index){
      return chatList[index];
    }

  static var itemCount = chatList.length;
  
}
