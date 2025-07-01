class EventUtils {
  static void sortEvents(List events, String sortType) {
    if (sortType == 'Date') {
      events.sort((a, b) => a.date.compareTo(b.date));
    } else if (sortType == 'Name') {
      events.sort((a, b) => a.title.compareTo(b.title));
    }
  }
}