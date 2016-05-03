# CDEmptyDataSet

`BaseEmptyViewController` is mainly used to handle the layout part of following scenes:

- `UITableView` or `UICollectionView` with empty data.
- Loading process of `UITableView` or `UICollectionView`.
- Network failure.
- Network loss.

Since they have similar layout of an image and a title, I choose to handle them in `BaseEmptyViewController`, which you can inherit from it.