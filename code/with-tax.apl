∇Z←WithTax ⍵;Rate;A;B;Cost
 ⍝ Calculate the price of an item including a 7% sales tax.
 ⍝
 ⍝ This is a CALCULATION.
 ⍝
 ⍝ Arguments
 ⍝ =========
 ⍝ ⍵ <number>: The price (in dollars) of the item before tax.
 ⍝
 ⍝ Local Variables
 ⍝ ===============
 ⍝ Rate <number>: A decimal representation of the sales tax rate.
 ⍝ Cost <number>: The cost of the item without tax, in cents.
 ⍝ A <number>: The exact cost with tax, in cents.
 ⍝ B <number>: The price with tax in cents, rounded up to the nearest cent.
 ⍝ Returns
 ⍝ =======
 ⍝ Z <string>: The full price of the item with tax, in dollars.
 ⍝
 ⍝ Impurities
 ⍝ ==========
 ⍝ None.
 ⍝
 ⍝ Assume a 7% Sales Tax.
 Rate←0.07
 ⍝ Convert the cost to cents for precision.
 Cost←⍵×100
 ⍝ The Main Calculation: Add the Amount to 7% of the Amount.
 A←Cost + Cost × Rate
 ⍝ Round up to the nearest cent.
 B←⌈A
 ⍝ Present the result in dollars.
 Z←10 2⍕(B÷100)
∇
