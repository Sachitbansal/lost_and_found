class RecentFile {
  final String? icon, title, date, size;

  RecentFile({this.icon, this.title, this.date, this.size});
}

List demoRecentItems = [
  RecentFile(
    icon: "assets/icons/xd_file.svg",
    title: "Calculator",
    date: "21/7/24",
    size: "Technical",
  ),
  RecentFile(
    icon: "assets/icons/Figma_file.svg",
    title: "Nike Shoes",
    date: "20/7/24",
    size: "Personal",
  ),
  RecentFile(
    icon: "assets/icons/doc_file.svg",
    title: "Waist Belt",
    date: "23/7/24",
    size: "Personal",
  ),
  RecentFile(
    icon: "assets/icons/sound_file.svg",
    title: "Physics Register",
    date: "22/7/24",
    size: "Academic",
  ),
  // RecentFile(
  //   icon: "assets/icons/media_file.svg",
  //   title: "Media File",
  //   date: "23-02-2021",
  //   size: "2.5gb",
  // ),
  // RecentFile(
  //   icon: "assets/icons/pdf_file.svg",
  //   title: "Sales PDF",
  //   date: "25-02-2021",
  //   size: "3.5mb",
  // ),
  // RecentFile(
  //   icon: "assets/icons/excel_file.svg",
  //   title: "Excel File",
  //   date: "25-02-2021",
  //   size: "34.5mb",
  // ),
];
