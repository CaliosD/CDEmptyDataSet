# CDEmptyDataSet

`BaseEmptyViewController` is mainly used to handle the layout part of following scenes:

- `UITableView` or `UICollectionView` with empty data.
- Network failure.
- Network loss.
- Loading process of `UITableView` or `UICollectionView`.

![][image-1]

## Instructures

- When handling with empty data, [DZNEmptyDataSet][1] helps so much. And if you merely want to handle empty data without having to inherit from any class, I recommend you to use it. So handy and fantastic!
- When handling with loading process, I find DGActivityIndicatorView meets every aspect of my need, so I choose not to *reinvent the wheel*. So, don’t forget to put it into your project as well.

## Requirements

* Xcode 7 or higher
* iOS 9.0 or higher (May work on previous version, just didn’t test it.)
* ARC

## Demo

Open and run the CDEmptyDataSet project in Xcode.

## Installation

All you need to do is drop BaseEmptyViewController and DGActivityIndicatorView folder into your project.

## How to use

### For use case 1-3

**Step 1:**

Inherit your view controller from it.

**Step 2:**

Tell the controller that you want it to handle empty data for you.

			self.needsEmptyDataHandling = YES;

Set your own empty title or image as you need, or just leave the default and do nothing.

	    self.emptyTitle = @"Sorry for the network failure";
	    self.emptyImage = [UIImage imageNamed:@"wifi-error.png"];

**Step 3:**

Remember to call both of the reload method at last.

	    [_yourTableView reloadData];
	    [self reloadEmptyDataWithType:EmptyType_EmptyData];

### For use case 4

**Step 1:**

Same as above.

**Step 2:**

Call the start or stop method where you need start or stop.

	    [self startLoading];

or

	    [self stopLoading];

will get the work done.



Now, you’ve got it. Then enjoy it. :P

## Contact

Calios

- Github: https://github.com/CaliosD
- Email: calios\_1124@163.com

[1]:	https://github.com/dzenbot/DZNEmptyDataSet

[image-1]:	https://raw.githubusercontent.com/CaliosD/CDEmptyDataSet/master/CDEmptyDataSet.gif