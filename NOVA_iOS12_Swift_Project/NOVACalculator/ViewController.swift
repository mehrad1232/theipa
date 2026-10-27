import UIKit
private enum E: Error { case incomplete, brackets, invalid, zero, fractional, overflow }
private struct Parser {
 private var s:[Character]; private var i=0
 init(_ x:String){s=Array(x.replacingOccurrences(of:"×",with:"*").replacingOccurrences(of:"÷",with:"/").replacingOccurrences(of:"−",with:"-").filter{$0 != " "})}
 mutating func run() throws -> Int64 {guard !s.isEmpty else{throw E.incomplete};let v=try expr();guard i==s.count else{throw E.invalid};return v}
 private mutating func expr() throws -> Int64 {var v=try term();while i<s.count && (s[i]=="+" || s[i]=="-"){let o=s[i];i+=1;let b=try term();let r=o=="+" ? v.addingReportingOverflow(b):v.subtractingReportingOverflow(b);if r.overflow{throw E.overflow};v=r.partialValue};return v}
 private mutating func term() throws -> Int64 {var v=try unary();while i<s.count && (s[i]=="*" || s[i]=="/"){let o=s[i];i+=1;let b=try unary();if o=="*"{let r=v.multipliedReportingOverflow(by:b);if r.overflow{throw E.overflow};v=r.partialValue}else{if b==0{throw E.zero};if v==Int64.min && b == -1{throw E.overflow};if v%b != 0{throw E.fractional};v/=b}};return v}
 private mutating func unary() throws -> Int64 {if i<s.count && (s[i]=="+" || s[i]=="-"){let o=s[i];i+=1;let v=try unary();if o=="-"{if v==Int64.min{throw E.overflow};return -v};return v};return try primary()}
 private mutating func primary() throws -> Int64 {guard i<s.count else{throw E.incomplete};if s[i]=="("{i+=1;let v=try expr();guard i<s.count && s[i]==")" else{throw E.brackets};i+=1;return v};let a=i;while i<s.count && s[i].isNumber{i+=1};guard i>a else{throw E.invalid};guard let v=Int64(String(s[a..<i])) else{throw E.overflow};return v}
}
final class ViewController:UIViewController {
 let bg=UIColor(red:0.035,green:0.055,blue:0.11,alpha:1), key=UIColor(red:0.075,green:0.105,blue:0.19,alpha:1), mint=UIColor(red:0.25,green:0.94,blue:0.77,alpha:1), violet=UIColor(red:0.62,green:0.57,blue:1,alpha:1)
 var expression="", answer="۰", finalMessage:String?
 let expLabel=UILabel(), resultLabel=UILabel(), status=UILabel()
 override var preferredStatusBarStyle:UIStatusBarStyle{.lightContent}
 override func viewDidLoad(){super.viewDidLoad();view.backgroundColor=bg;build();refresh()}
 func build(){
  let g=CAGradientLayer();g.colors=[UIColor(red:0.09,green:0.1,blue:0.23,alpha:1).cgColor,bg.cgColor];g.frame=UIScreen.main.bounds;view.layer.insertSublayer(g,at:0)
  let scroll=UIScrollView();scroll.translatesAutoresizingMaskIntoConstraints=false;view.addSubview(scroll)
  NSLayoutConstraint.activate([scroll.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor,constant:5),scroll.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor,constant:-5),scroll.leadingAnchor.constraint(equalTo:view.leadingAnchor,constant:12),scroll.trailingAnchor.constraint(equalTo:view.trailingAnchor,constant:-12)])
  let stack=UIStackView();stack.axis = .vertical;stack.spacing=10;stack.translatesAutoresizingMaskIntoConstraints=false;scroll.addSubview(stack)
  NSLayoutConstraint.activate([stack.topAnchor.constraint(equalTo:scroll.contentLayoutGuide.topAnchor),stack.bottomAnchor.constraint(equalTo:scroll.contentLayoutGuide.bottomAnchor),stack.leadingAnchor.constraint(equalTo:scroll.frameLayoutGuide.leadingAnchor),stack.trailingAnchor.constraint(equalTo:scroll.frameLayoutGuide.trailingAnchor)])
  stack.addArrangedSubview(label("N O V A",13,.heavy,mint,.center));stack.addArrangedSubview(label("ماشین‌حساب اعداد صحیح",22,.bold,.white,.center));stack.addArrangedSubview(label("عبارت کامل • پرانتز • قرینه‌ها",12,.medium,UIColor(white:0.72,alpha:1),.center))
  let box=UIView();box.backgroundColor=UIColor(white:1,alpha:0.055);box.layer.cornerRadius=20;box.layer.borderWidth=1;box.layer.borderColor=UIColor(white:1,alpha:0.09).cgColor;box.translatesAutoresizingMaskIntoConstraints=false;stack.addArrangedSubview(box);box.heightAnchor.constraint(greaterThanOrEqualToConstant:124).isActive=true
  let caption=label("عبارت شما",12,.medium,violet,.right);expLabel.font=UIFont.monospacedDigitSystemFont(ofSize:20,weight:.medium);expLabel.textColor=UIColor(white:0.92,alpha:1);expLabel.textAlignment = .right;expLabel.numberOfLines=2;expLabel.adjustsFontSizeToFitWidth=true
  resultLabel.font=UIFont.monospacedDigitSystemFont(ofSize:34,weight:.bold);resultLabel.textColor=mint;resultLabel.textAlignment = .right;resultLabel.adjustsFontSizeToFitWidth=true
  [caption,expLabel,resultLabel].forEach{$0.translatesAutoresizingMaskIntoConstraints=false;box.addSubview($0)}
  NSLayoutConstraint.activate([caption.topAnchor.constraint(equalTo:box.topAnchor,constant:12),caption.leadingAnchor.constraint(equalTo:box.leadingAnchor,constant:14),caption.trailingAnchor.constraint(equalTo:box.trailingAnchor,constant:-14),expLabel.topAnchor.constraint(equalTo:caption.bottomAnchor,constant:4),expLabel.leadingAnchor.constraint(equalTo:box.leadingAnchor,constant:14),expLabel.trailingAnchor.constraint(equalTo:box.trailingAnchor,constant:-14),resultLabel.topAnchor.constraint(equalTo:expLabel.bottomAnchor,constant:4),resultLabel.leadingAnchor.constraint(equalTo:box.leadingAnchor,constant:14),resultLabel.trailingAnchor.constraint(equalTo:box.trailingAnchor,constant:-14),resultLabel.bottomAnchor.constraint(equalTo:box.bottomAnchor,constant:-10)])
  status.backgroundColor=UIColor(white:1,alpha:0.045);status.layer.cornerRadius=10;status.layer.masksToBounds=true;status.font=UIFont.systemFont(ofSize:11,weight:.medium);status.textAlignment = .center;status.numberOfLines=2;stack.addArrangedSubview(status);status.heightAnchor.constraint(greaterThanOrEqualToConstant:36).isActive=true
  let rows:[[(String,String)]]=[[("۷","7"),("۸","8"),("۹","9"),("÷","÷")],[("۴","4"),("۵","5"),("۶","6"),("×","×")],[("۱","1"),("۲","2"),("۳","3"),("−","−")],[("(","("),("۰","0"),(")",")"),("+","+")],[("±","sign"),("⌫","back"),("پاک","clear"),("=","equals")]]
  for row in rows{let line=UIStackView();line.axis = .horizontal;line.spacing=8;line.distribution = .fillEqually
   for (title,action) in row{let b=UIButton(type:.custom);b.setTitle(title,for:.normal);b.titleLabel?.font=UIFont.systemFont(ofSize:title=="پاک" ? 14:22,weight:.semibold);b.backgroundColor=key;b.layer.cornerRadius=14;b.setTitleColor(.white,for:.normal);b.accessibilityIdentifier=action
    if action=="equals"{b.backgroundColor=mint;b.setTitleColor(bg,for:.normal)}else if action=="clear"{b.backgroundColor=UIColor(red:0.35,green:0.12,blue:0.20,alpha:1);b.setTitleColor(.systemPink,for:.normal)}else if ["+","−","×","÷","(",")","sign","back"].contains(action){b.setTitleColor(violet,for:.normal)}
    b.addTarget(self,action:#selector(tap(_:)),for:.touchUpInside);line.addArrangedSubview(b);b.heightAnchor.constraint(equalToConstant:46).isActive=true
   };stack.addArrangedSubview(line)}
  stack.addArrangedSubview(label("تقسیم فقط با جواب صحیح پذیرفته می‌شود",11,.regular,UIColor(white:0.58,alpha:1),.center))
 }
 func label(_ text:String,_ size:CGFloat,_ weight:UIFont.Weight,_ color:UIColor,_ align:NSTextAlignment)->UILabel{let l=UILabel();l.text=text;l.font=UIFont.systemFont(ofSize:size,weight:weight);l.textColor=color;l.textAlignment=align;l.adjustsFontSizeToFitWidth=true;l.minimumScaleFactor=0.7;return l}
 @objc func tap(_ sender:UIButton){guard let a=sender.accessibilityIdentifier else{return};finalMessage=nil
  switch a{case "clear":expression="";answer="۰"
  case "back":if !expression.isEmpty{expression.removeLast()}
  case "sign":if expression.isEmpty{expression="−"}else if let last=expression.last,last.isNumber{var start=expression.endIndex;while start>expression.startIndex{let p=expression.index(before:start);if expression[p].isNumber{start=p}else{break}};if start>expression.startIndex && expression[expression.index(before:start)]=="−"{expression.remove(at:expression.index(before:start))}else{expression.insert(contentsOf:"−",at:start)}}else{expression += "−"}
  case "equals":calculate();return
  default:if ["0","1","2","3","4","5","6","7","8","9","+","−","×","÷","(",")"].contains(a) && expression.count<90{expression += a}
  };refresh()
 }
 func calculate(){var depth=0;for c in expression{if c=="("{depth+=1};if c==")"{depth-=1};if depth<0{finalMessage="پرانتز بستهٔ اضافی وجود دارد";refresh();return}};guard depth==0 else{finalMessage="یک پرانتز باز مانده است";refresh();return}
  do{var p=Parser(expression);answer=String(try p.run());finalMessage="درست است ✓ قرینه‌ها و پرانتزها بررسی شدند"}
  catch E.zero{finalMessage="تقسیم بر صفر مجاز نیست"}catch E.fractional{finalMessage="نتیجهٔ تقسیم عدد صحیح نیست"}catch E.overflow{finalMessage="عدد از محدودهٔ محاسبه بزرگ‌تر است"}catch E.brackets{finalMessage="پرانتزها کامل نیستند"}catch{finalMessage="عبارت را کامل و درست وارد کن"};refresh()
 }
 func refresh(){expLabel.text=expression.isEmpty ? "مثلاً ۸ + (−۳)":expression;resultLabel.text=answer
  if let m=finalMessage{status.text=m;status.textColor=m.hasPrefix("درست") ? mint:.systemPink;return}
  var depth=0,bad=false;for c in expression{if c=="("{depth+=1};if c==")"{depth-=1};if depth<0{bad=true}}
  if bad{status.text="پرانتز بستهٔ اضافی وجود دارد";status.textColor = .systemPink}else if depth>0{status.text="پرانتز باز مانده: "+String(depth);status.textColor=violet}else{status.text="✓ پرانتزها متعادل‌اند • قرینه‌ها خودکار بررسی می‌شوند";status.textColor=mint}
 }
}