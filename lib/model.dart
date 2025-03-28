class Note {
  int? id ;
  String title ;
  String desc ;

  Note(this.title,this.desc,[this.id]);

  Map<String,dynamic> toMap () => {
    'id' : id,
    'title' : title,
    'desc' : desc,
  };

}