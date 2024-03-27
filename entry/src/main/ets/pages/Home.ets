/**
 * ListPage is the entry of application and shows how to develop a list page.The page consists of the search component,
 * list, and tabs. The list component is ListAreaComponent, and each item in the list corresponds to ListItemComponent.
 * The LazyForEach interface is used to implement high performance. Developers can expand
 * ListItemData, TabItemData, and PageViewModel, modify or add your own text, pictures, etc,
 * and quickly develop functions that meet project requirements.
 */
@Entry
@Component
struct ListPage {
  @State title: string = 'hello oh';

  build() {
    Column() {
      Row() {
        Text(this.title)
      }
    }
  }
}