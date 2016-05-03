# CDEmptyDataSet

`BaseEmptyViewController` is mainly used to handle the layout part of following scenes:

- `UITableView` or `UICollectionView` with empty data.
- Loading process of `UITableView` or `UICollectionView`.
- Network failure.
- Network loss.

![][image-1]

## Requirements

* Xcode 7 or higher
* iOS 9.0 or higher (May work on previous version, just didn’t test it.)
* ARC

## Demo

Open and run the CDEmptyDataSet project in Xcode.

## Installation

All you need to do is drop BaseEmptyViewController folder into your project.

## How to use

**Step 1:**

Inherit your view controller from it.

**Step 2:**

Set your own empty title or image as you need, or just leave the default.

		self.emptyTitle = @"Sorry for the network failure";
	    self.emptyImage = [UIImage imageNamed:@"wifi-error.png"];

**Step 3:**

Remember to call both of the reload function at last.

			[_tableView reloadData];
	    [self reloadEmptyData];

Done! And enjoy it. :P

## Contact

Calios

- Github: https://github.com/CaliosD
- Email: calios\_1124@163.com

[image-1]:	https://raw.githubusercontent.com/CaliosD/CDEmptyDataSet/master/CDEmptyDataSet.gif