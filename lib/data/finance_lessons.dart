import 'package:cloud_firestore/cloud_firestore.dart';

class FinanceLessonsData {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final List<Map<String, dynamic>> lessons = [
    {
      'title': 'Introduction to Personal Finance',
      'description':
          'Learn the basics of managing your money and setting financial goals.',
      'content': '''
# Introduction to Personal Finance

## What is Personal Finance?
Personal finance refers to managing your money, savings, investments, and spending. It encompasses budgeting, banking, insurance, mortgages, investments, retirement planning, and tax and estate planning.

## Why is Personal Finance Important?
Understanding personal finance is crucial for:
- Meeting your short-term and long-term needs
- Building wealth and security
- Reducing financial stress
- Achieving financial freedom

## Key Elements of Personal Finance
### 1. Income Management
Your income is the foundation of your financial plan. This includes:
- Salary and wages
- Investment income
- Side hustle earnings
- Passive income

### 2. Spending
How you spend your money determines your financial health:
- Needs vs. wants
- Fixed expenses vs. variable expenses
- Conscious spending decisions

### 3. Saving
Saving is essential for future financial security:
- Emergency fund (3-6 months of expenses)
- Short-term goals (vacation, new car)
- Long-term goals (house down payment)

### 4. Investing
Growing your wealth through strategic investments:
- Stocks and bonds
- Mutual funds and ETFs
- Real estate
- Retirement accounts (401(k), IRA)

### 5. Protection
Safeguarding your financial future:
- Insurance (health, life, disability, property)
- Estate planning
- Identity theft protection

## Creating a Personal Finance Plan

1. **Assess your current financial situation**
   - Calculate your net worth
   - Review your income and expenses
   - Check your credit score

2. **Set SMART financial goals**
   - Specific
   - Measurable
   - Achievable
   - Relevant
   - Time-bound

3. **Create a budget**
   - Track income and expenses
   - Allocate funds to different categories
   - Review and adjust regularly

4. **Build an emergency fund**
   - Start with \$1,000
   - Work toward 3-6 months of expenses

5. **Pay off debt**
   - List all debts
   - Choose a repayment strategy (avalanche or snowball)
   - Make consistent payments

6. **Save and invest for the future**
   - Retirement accounts
   - Education funds
   - Other investments

## Next Steps
In the upcoming lessons, we'll dive deeper into each of these areas, starting with budgeting and expense tracking.
''',
      'order': 1,
      'tags': ['beginner', 'basics', 'finance'],
      'durationMinutes': 15,
      'imageUrl': 'assets/images/banner1.png',
    },
    {
      'title': 'Budgeting Fundamentals',
      'description':
          'Create and maintain a budget that helps you achieve your financial goals.',
      'content': '''
# Budgeting Fundamentals

## What is a Budget?
A budget is a financial plan that allocates your income towards expenses, savings, and debt repayment. It's a roadmap for your money that helps you make informed decisions.

## The 50/30/20 Rule
A simple budgeting framework:
- 50% for needs (housing, food, utilities)
- 30% for wants (entertainment, dining out)
- 20% for savings and debt repayment

## Creating Your Budget

### Step 1: Calculate Your Income
- List all sources of income
- Use after-tax (take-home) amounts
- For irregular income, use a conservative estimate

### Step 2: Track Your Expenses
Categories to consider:
- Housing (rent/mortgage, insurance, property taxes)
- Utilities (electricity, water, gas, internet)
- Food (groceries, dining out)
- Transportation (car payment, gas, maintenance, public transit)
- Insurance (health, auto, life)
- Debt payments (student loans, credit cards)
- Personal (clothing, haircuts, gym)
- Entertainment (streaming services, hobbies)
- Savings (emergency fund, retirement, other goals)

### Step 3: Set Financial Goals
- Short-term goals (1 year or less)
- Medium-term goals (1-5 years)
- Long-term goals (more than 5 years)

### Step 4: Create Your Budget Plan
- Allocate money to each category
- Ensure total expenses don't exceed income
- Include savings as a non-negotiable expense

### Step 5: Implement and Track
- Use budgeting tools (apps, spreadsheets)
- Review weekly and adjust as needed
- Celebrate small victories

## Common Budgeting Methods

### Zero-Based Budget
Every dollar has a job. Income minus expenses equals zero.

### Envelope System
Cash is placed in envelopes labeled for different spending categories.

### Pay Yourself First
Automatically save a portion of income before budgeting the rest.

### Values-Based Budget
Align spending with personal values and priorities.

## Tips for Successful Budgeting

1. **Be realistic** - Don't set unreasonable restrictions
2. **Build in flexibility** - Life happens, have buffer categories
3. **Automate what you can** - Bill payments, savings transfers
4. **Review regularly** - Monthly check-ins are essential
5. **Adjust as needed** - Your budget should evolve with your life
6. **Don't give up** - It takes time to find what works for you

## Budgeting Tools
- Spreadsheets (Excel, Google Sheets)
- Apps (Mint, YNAB, Personal Capital)
- Traditional pen and paper

## Next Steps
In our next lesson, we'll explore debt management strategies and how to prioritize which debts to pay off first.
''',
      'order': 2,
      'tags': ['budgeting', 'planning', 'money management'],
      'durationMinutes': 20,
      'imageUrl': 'assets/images/notes.png',
    },
    {
      'title': 'Debt Management Strategies',
      'description':
          'Learn effective methods to pay off debt and improve your financial health.',
      'content': '''
# Debt Management Strategies

## Understanding Your Debt
Different types of debt have different impacts on your financial health:

### Good Debt vs. Bad Debt
- **Good debt**: Potentially increases net worth or income (mortgage, student loans, business loans)
- **Bad debt**: Decreases net worth and typically has high interest (credit cards, payday loans)

### Secured vs. Unsecured Debt
- **Secured debt**: Backed by collateral (mortgage, auto loan)
- **Unsecured debt**: Not backed by assets (credit cards, personal loans)

## Assessing Your Debt Situation

1. **List all debts**
   - Creditor name
   - Current balance
   - Interest rate
   - Minimum payment
   - Due date

2. **Calculate your debt-to-income ratio**
   - Total monthly debt payments ÷ Gross monthly income
   - Below 36% is generally considered healthy

## Debt Repayment Strategies

### Debt Avalanche Method
- Focus on highest interest rate debt first
- Make minimum payments on all other debts
- Apply extra money to highest interest debt
- Once paid off, move to next highest interest debt
- **Best for**: Minimizing total interest paid

### Debt Snowball Method
- Focus on smallest balance debt first
- Make minimum payments on all other debts
- Apply extra money to smallest balance debt
- Once paid off, move to next smallest balance
- **Best for**: Building motivation through quick wins

### Debt Consolidation
- Combine multiple debts into a single loan with a lower interest rate
- Options include:
  - Personal consolidation loans
  - Balance transfer credit cards
  - Home equity loans (if you own a home)
- **Best for**: Simplifying payments and potentially reducing interest

### Debt Management Plans
- Work with a credit counseling agency
- Negotiate with creditors for lower interest rates or fees
- Make one monthly payment to the agency
- **Best for**: Those needing professional guidance

## Creating Your Debt Payoff Plan

1. **Choose your strategy** (avalanche or snowball)
2. **Set up automatic minimum payments** for all debts
3. **Determine how much extra** you can put toward debt each month
4. **Track your progress** regularly
5. **Celebrate milestones** along the way

## Finding Money for Debt Repayment

- Review your budget for potential cuts
- Sell items you no longer need
- Consider a temporary side hustle
- Reduce or pause retirement contributions (temporarily)
- Use windfalls (tax refunds, bonuses) for debt payoff

## Avoiding Future Debt

- Build an emergency fund
- Practice delayed gratification
- Use cash or debit cards for purchases
- Check in with your budget regularly
- Address spending triggers

## When to Seek Professional Help

- If you can't make minimum payments
- If debt collectors are calling
- If you're considering bankruptcy
- If debt is causing significant stress or relationship problems

## Next Steps
In our next lesson, we'll explore saving and investment strategies to help you build wealth once you've addressed your debt.
''',
      'order': 3,
      'tags': ['debt', 'credit', 'financial planning'],
      'durationMinutes': 25,
      'imageUrl': 'assets/images/banner3.png',
    },
    {
      'title': 'Investing Basics',
      'description':
          'Understand how to start investing and building wealth for the future.',
      'content': '''
# Investing Basics

## Why Invest?
Investing allows your money to work for you through:
- Compound interest
- Capital appreciation
- Passive income
- Beating inflation

## Investment Fundamentals

### Risk and Return
- Higher potential returns typically involve higher risk
- Lower risk investments generally offer lower returns
- Your risk tolerance depends on:
  - Age and time horizon
  - Financial goals
  - Personal comfort level

### Diversification
- Spreading investments across different assets
- Reduces exposure to any single investment
- "Don't put all your eggs in one basket"

### Time Horizon
- Short-term: Less than 3 years
- Medium-term: 3-10 years
- Long-term: More than 10 years

## Types of Investments

### Stocks (Equities)
- Ownership shares in a company
- Potential for growth and dividends
- Higher risk, higher potential reward
- Best for long-term goals

### Bonds (Fixed Income)
- Loans to companies or governments
- Regular interest payments
- Lower risk than stocks
- Good for medium-term goals

### Mutual Funds and ETFs
- Pools of stocks, bonds, or other assets
- Professional management
- Instant diversification
- Various risk/return profiles

### Real Estate
- Physical property or REITs (Real Estate Investment Trusts)
- Potential for income and appreciation
- Can provide tax advantages
- Less liquid than stocks or bonds

### Cash and Cash Equivalents
- Savings accounts, money market funds, CDs
- Very low risk
- Low returns, often below inflation
- Good for short-term goals and emergency funds

## Getting Started with Investing

### Step 1: Set Clear Goals
- What are you investing for?
- How long until you need the money?
- How much do you need?

### Step 2: Assess Your Risk Tolerance
- Conservative, moderate, or aggressive
- Consider both financial and emotional capacity for risk

### Step 3: Choose an Account Type
- **Retirement accounts**:
  - 401(k) or 403(b) through employer
  - Traditional IRA or Roth IRA
  - SEP IRA or Solo 401(k) for self-employed
- **Taxable accounts**:
  - Brokerage accounts
  - No tax advantages but more flexibility

### Step 4: Select an Investment Platform
- Traditional brokerages (Fidelity, Charles Schwab, Vanguard)
- Online brokerages (E*TRADE, TD Ameritrade)
- Robo-advisors (Betterment, Wealthfront)
- Micro-investing apps (Acorns, Stash)

### Step 5: Create Your Investment Strategy
- Asset allocation based on goals and risk tolerance
- Consider index funds for beginners
- Start with small, regular contributions

## Common Investment Strategies

### Buy and Hold
- Purchase investments and hold for the long term
- Less time-intensive
- Takes advantage of market growth over time

### Dollar-Cost Averaging
- Invest a fixed amount regularly
- Automatically buys more when prices are low
- Reduces impact of market volatility

### Index Investing
- Passive strategy tracking market indexes
- Lower fees than actively managed funds
- Historically outperforms most active management

## Avoiding Common Mistakes

- Investing before having an emergency fund
- Trying to time the market
- Checking investments too frequently
- Letting emotions drive decisions
- Paying high fees
- Not rebalancing periodically

## Next Steps
In our next lesson, we'll discuss retirement planning and the various account types available for long-term investing.
''',
      'order': 4,
      'tags': ['investing', 'stocks', 'financial growth'],
      'durationMinutes': 30,
      'imageUrl': 'assets/images/banner4.png',
    },
    {
      'title': 'Building an Emergency Fund',
      'description':
          'Learn why and how to create a financial safety net for unexpected expenses.',
      'content': '''
# Building an Emergency Fund

## What is an Emergency Fund?
An emergency fund is money set aside specifically for unexpected expenses or financial emergencies, such as:
- Job loss
- Medical emergencies
- Major home repairs
- Car repairs
- Family emergencies

## Why You Need an Emergency Fund
- Prevents taking on debt during emergencies
- Reduces financial stress
- Provides peace of mind
- Creates financial stability
- Allows you to focus on long-term goals

## How Much Should You Save?
### General Guidelines:
- **Beginner**: \$1,000 as a starter fund
- **Established**: 3-6 months of essential expenses
- **Self-employed/Variable income**: 6-12 months of essential expenses

### Factors to Consider:
- Job stability
- Number of income earners in household
- Health status
- Dependents
- Insurance coverage
- Debt obligations

## Where to Keep Your Emergency Fund
Your emergency fund should be:
- **Liquid**: Easily accessible without penalties
- **Safe**: Not subject to market fluctuations
- **Separate**: Not mixed with everyday spending money

### Best Account Options:
- High-yield savings accounts
- Money market accounts
- Cash management accounts
- Short-term CDs (certificate of deposit)

## Building Your Emergency Fund

### Step 1: Set a Clear Target
- Calculate your monthly essential expenses
- Multiply by your target months of coverage
- Start with a smaller goal if the full amount seems overwhelming

### Step 2: Create a Funding Plan
- Automatic transfers from checking to savings
- Consistent contributions (treat like a bill)
- Determine how much you can reasonably save each month

### Step 3: Find Extra Money to Contribute
- Tax refunds
- Work bonuses
- Gifts
- Side hustle income
- Selling unused items
- Reducing expenses

### Step 4: Track Your Progress
- Set milestones (e.g., \$1,000, one month of expenses, etc.)
- Celebrate reaching each milestone
- Adjust contributions as your financial situation changes

## When to Use Your Emergency Fund
### Appropriate Uses:
- Unexpected medical bills
- Job loss
- Major home or car repairs
- Emergency travel

### Not Appropriate Uses:
- Planned expenses (holiday gifts, vacations)
- Non-essential purchases
- Regular monthly bills
- Investing opportunities

## Replenishing Your Emergency Fund
- Make it a priority after using it
- Adjust your budget temporarily if needed
- Consider increasing the fund if it wasn't sufficient

## Emergency Fund vs. Other Financial Priorities
### Order of Financial Operations:
1. Build a starter emergency fund (\$1,000)
2. Pay off high-interest debt
3. Contribute to retirement to get employer match
4. Build full emergency fund
5. Pay off remaining debt
6. Increase retirement savings
7. Save for other goals

## Next Steps
In our next lesson, we'll discuss insurance and how to properly protect yourself and your assets from financial risks.
''',
      'order': 5,
      'tags': ['savings', 'emergency fund', 'financial security'],
      'durationMinutes': 20,
      'imageUrl': 'assets/images/banner5.png',
    },
  ];

  static final List<Map<String, dynamic>> flashcards = [
    {
      'question': 'What is the 50/30/20 budgeting rule?',
      'answer':
          '50% for needs, 30% for wants, and 20% for savings and debt repayment.',
      'lessonId': '2', // Will be updated when lessons are created
      'order': 1,
    },
    {
      'question':
          'What is the difference between the debt avalanche and debt snowball methods?',
      'answer':
          'The debt avalanche method focuses on paying off debts with the highest interest rates first, while the debt snowball method focuses on paying off the smallest debts first.',
      'lessonId': '3', // Will be updated when lessons are created
      'order': 1,
    },
    {
      'question': 'What is compound interest?',
      'answer':
          "Compound interest is when you earn interest on both the money you've saved and the interest you earn. It's essentially \"interest on interest\" and helps your money grow faster over time.",
      'lessonId': '4', // Will be updated when lessons are created
      'order': 1,
    },
    {
      'question': 'What is diversification in investing?',
      'answer':
          "Diversification means spreading your investments across different asset types to reduce risk. It's the investment version of \"don't put all your eggs in one basket.\"",
      'lessonId': '4', // Will be updated when lessons are created
      'order': 2,
    },
    {
      'question': 'What is the recommended size of an emergency fund?',
      'answer':
          'Generally, 3-6 months of essential expenses. Self-employed individuals or those with variable income may need 6-12 months.',
      'lessonId': '5', // Will be updated when lessons are created
      'order': 1,
    },
    {
      'question':
          'What is the difference between a need and a want in budgeting?',
      'answer':
          "Needs are essential expenses required for survival (housing, food, utilities), while wants are non-essential expenses that enhance life but aren't required (entertainment, dining out).",
      'lessonId': '2', // Will be updated when lessons are created
      'order': 2,
    },
    {
      'question': 'What is a good debt-to-income ratio?',
      'answer':
          'A debt-to-income ratio below 36% is generally considered healthy. This ratio is calculated by dividing your total monthly debt payments by your gross monthly income.',
      'lessonId': '3', // Will be updated when lessons are created
      'order': 2,
    },
    {
      'question': 'What is the difference between stocks and bonds?',
      'answer':
          'Stocks represent ownership in a company, while bonds are loans to a company or government. Stocks typically have higher risk and potential return than bonds.',
      'lessonId': '4', // Will be updated when lessons are created
      'order': 3,
    },
    {
      'question': 'What is the purpose of an emergency fund?',
      'answer':
          'An emergency fund provides financial security for unexpected expenses like medical emergencies, car repairs, or job loss, preventing the need to take on debt during difficult times.',
      'lessonId': '5', // Will be updated when lessons are created
      'order': 2,
    },
    {
      'question': 'What is a SMART financial goal?',
      'answer':
          'A SMART financial goal is Specific, Measurable, Achievable, Relevant, and Time-bound. This framework helps create clear and attainable financial objectives.',
      'lessonId': '1', // Will be updated when lessons are created
      'order': 1,
    },
  ];

  static final List<Map<String, dynamic>> quizzes = [
    {
      'title': 'Personal Finance Basics Quiz',
      'description': 'Test your knowledge of personal finance fundamentals',
      'lessonId': '1', // Will be updated when lessons are created
      'questions': [
        {
          'question': 'What are the key elements of personal finance?',
          'options': [
            'Income, spending, saving, investing, and protection',
            'Stocks, bonds, real estate, and cash',
            'Budgeting, debt, and credit',
            'Income taxes, sales taxes, and property taxes',
          ],
          'correctOptionIndex': 0,
          'explanation':
              'The five key elements of personal finance are income management, spending, saving, investing, and protection.',
        },
        {
          'question': 'What does a personal net worth calculation include?',
          'options': [
            'Only your assets',
            'Only your liabilities',
            'Assets minus liabilities',
            'Income minus expenses',
          ],
          'correctOptionIndex': 2,
          'explanation':
              'Net worth is calculated by subtracting your total liabilities (what you owe) from your total assets (what you own).',
        },
        {
          'question': 'What does the "M" stand for in SMART financial goals?',
          'options': ['Manageable', 'Measurable', 'Meaningful', 'Monetary'],
          'correctOptionIndex': 1,
          'explanation':
              'SMART goals are Specific, Measurable, Achievable, Relevant, and Time-bound.',
        },
        {
          'question':
              'Which of the following is NOT typically considered a fixed expense?',
          'options': [
            'Mortgage payment',
            'Car insurance premium',
            'Grocery shopping',
            'Internet bill',
          ],
          'correctOptionIndex': 2,
          'explanation':
              'Grocery shopping is typically a variable expense because the amount spent can change from month to month.',
        },
        {
          'question':
              'What is the recommended size of an emergency fund for most people?',
          'options': [
            '\$100 - \$500',
            '\$1,000',
            '1-2 months of expenses',
            '3-6 months of expenses',
          ],
          'correctOptionIndex': 3,
          'explanation':
              'Financial experts generally recommend having 3-6 months of essential expenses saved in an emergency fund.',
        },
      ],
      'passingScore': 70,
      'timeLimit': 10,
    },
    {
      'title': 'Budgeting Quiz',
      'description': 'Test your knowledge of budgeting concepts',
      'lessonId': '2', // Will be updated when lessons are created
      'questions': [
        {
          'question': 'What is the 50/30/20 budgeting rule?',
          'options': [
            '50% needs, 30% wants, 20% savings and debt',
            '50% savings, 30% needs, 20% wants',
            '50% debt repayment, 30% needs, 20% savings',
            '50% wants, 30% needs, 20% investments',
          ],
          'correctOptionIndex': 0,
          'explanation':
              'The 50/30/20 rule suggests allocating 50% of your income to needs, 30% to wants, and 20% to savings and debt repayment.',
        },
        {
          'question':
              'Which budgeting method involves giving every dollar a specific job?',
          'options': [
            'Pay Yourself First',
            'Envelope System',
            'Values-Based Budgeting',
            'Zero-Based Budgeting',
          ],
          'correctOptionIndex': 3,
          'explanation':
              'Zero-based budgeting requires allocating every dollar of income to a specific category so that income minus expenses equals zero.',
        },
        {
          'question':
              'What type of expenses are rent/mortgage, utilities, and groceries?',
          'options': [
            'Discretionary expenses',
            'Fixed expenses',
            'Needs',
            'Wants',
          ],
          'correctOptionIndex': 2,
          'explanation':
              'Rent/mortgage, utilities, and groceries are considered needs because they are essential for survival.',
        },
        {
          'question':
              'Which of the following is NOT a recommended budgeting tool?',
          'options': [
            'Spreadsheets (Excel, Google Sheets)',
            'Budgeting apps (Mint, YNAB)',
            'Credit cards',
            'Pen and paper',
          ],
          'correctOptionIndex': 2,
          'explanation':
              'Credit cards are payment methods, not budgeting tools. The other options are all valid ways to track and manage your budget.',
        },
        {
          'question': 'How often should you review your budget?',
          'options': ['Daily', 'Weekly', 'Monthly', 'Yearly'],
          'correctOptionIndex': 2,
          'explanation':
              'Monthly reviews are generally recommended to track progress and make adjustments as needed.',
        },
      ],
      'passingScore': 70,
      'timeLimit': 10,
    },
    {
      'title': 'Debt Management Quiz',
      'description': 'Test your knowledge of debt concepts and strategies',
      'lessonId': '3', // Will be updated when lessons are created
      'questions': [
        {
          'question': 'What is considered "good debt"?',
          'options': [
            'Credit card debt',
            'Payday loans',
            'Student loans for education',
            'High-interest personal loans',
          ],
          'correctOptionIndex': 2,
          'explanation':
              'Good debt typically includes loans that can increase your net worth or income over time, such as student loans, mortgages, or business loans.',
        },
        {
          'question': 'What is the debt avalanche method?',
          'options': [
            'Paying off the smallest debt first',
            'Paying off the highest interest rate debt first',
            'Paying all debts equally',
            'Consolidating all debts into one loan',
          ],
          'correctOptionIndex': 1,
          'explanation':
              'The debt avalanche method involves focusing on paying off the debt with the highest interest rate first while making minimum payments on other debts.',
        },
        {
          'question':
              'What is generally considered a healthy debt-to-income ratio?',
          'options': ['Below 10%', 'Below 25%', 'Below 36%', 'Below 50%'],
          'correctOptionIndex': 2,
          'explanation':
              'A debt-to-income ratio below 36% is generally considered healthy for most consumers.',
        },
        {
          'question':
              'Which debt repayment strategy is likely to save you the most money in interest?',
          'options': [
            'Debt snowball',
            'Debt avalanche',
            'Paying minimum payments only',
            'Debt consolidation',
          ],
          'correctOptionIndex': 1,
          'explanation':
              'The debt avalanche method (paying highest interest debts first) typically saves the most money in interest over time.',
        },
        {
          'question': 'What is secured debt?',
          'options': [
            'Debt that is guaranteed by the government',
            'Debt backed by collateral',
            'Debt with a fixed interest rate',
            'Debt that cannot be discharged in bankruptcy',
          ],
          'correctOptionIndex': 1,
          'explanation':
              'Secured debt is backed by collateral, such as a car loan secured by the vehicle or a mortgage secured by the home.',
        },
      ],
      'passingScore': 70,
      'timeLimit': 10,
    },
    {
      'title': 'Investing Basics Quiz',
      'description': 'Test your knowledge of investment fundamentals',
      'lessonId': '4', // Will be updated when lessons are created
      'questions': [
        {
          'question':
              'What is the relationship between risk and potential return?',
          'options': [
            'Higher risk typically means lower potential returns',
            'Higher risk typically means higher potential returns',
            'Risk and return are not related',
            'All investments have the same risk and return profile',
          ],
          'correctOptionIndex': 1,
          'explanation':
              'Generally, investments with higher potential returns come with higher risk, while lower-risk investments typically offer lower potential returns.',
        },
        {
          'question': 'What is diversification?',
          'options': [
            'Investing only in the highest-performing assets',
            'Spreading investments across different assets to reduce risk',
            'Investing only in stocks',
            'Changing your investment strategy frequently',
          ],
          'correctOptionIndex': 1,
          'explanation':
              'Diversification involves spreading investments across different assets or asset classes to reduce exposure to any single investment.',
        },
        {
          'question':
              'Which investment type typically has the highest risk and potential return over the long term?',
          'options': [
            'Savings accounts',
            'Bonds',
            'Stocks',
            'Certificates of deposit (CDs)',
          ],
          'correctOptionIndex': 2,
          'explanation':
              'Historically, stocks have provided the highest returns over long time periods, but they also come with more volatility and risk.',
        },
        {
          'question': 'What is dollar-cost averaging?',
          'options': [
            'Investing a lump sum all at once',
            'Investing only in assets priced in dollars',
            'Investing a fixed amount regularly regardless of price',
            'Trying to time the market for the best price',
          ],
          'correctOptionIndex': 2,
          'explanation':
              'Dollar-cost averaging involves investing a fixed amount at regular intervals, regardless of asset prices, which can reduce the impact of market volatility.',
        },
        {
          'question':
              'Which account type offers tax advantages for retirement savings?',
          'options': [
            'Standard checking account',
            'Regular brokerage account',
            '401(k) or IRA',
            'Money market account',
          ],
          'correctOptionIndex': 2,
          'explanation':
              '401(k) plans and Individual Retirement Accounts (IRAs) offer tax advantages specifically designed for retirement savings.',
        },
      ],
      'passingScore': 70,
      'timeLimit': 10,
    },
    {
      'title': 'Emergency Fund Quiz',
      'description': 'Test your knowledge about emergency funds',
      'lessonId': '5', // Will be updated when lessons are created
      'questions': [
        {
          'question': 'What is an emergency fund?',
          'options': [
            'Money set aside for vacations',
            'Money for retirement',
            'Money saved specifically for unexpected expenses',
            'Money invested in the stock market',
          ],
          'correctOptionIndex': 2,
          'explanation':
              'An emergency fund is money set aside specifically for unexpected expenses or financial emergencies.',
        },
        {
          'question':
              'How much should a fully-funded emergency fund contain for most people?',
          'options': [
            '\$500 - \$1,000',
            '1-2 months of expenses',
            '3-6 months of expenses',
            'At least 1 year of expenses',
          ],
          'correctOptionIndex': 2,
          'explanation':
              'Most financial experts recommend having 3-6 months of essential expenses in your emergency fund.',
        },
        {
          'question': 'Where should you keep your emergency fund?',
          'options': [
            'In stocks or mutual funds',
            'In a high-yield savings account or money market account',
            'In cryptocurrency',
            'In your checking account mixed with spending money',
          ],
          'correctOptionIndex': 1,
          'explanation':
              'Emergency funds should be kept in liquid, safe accounts like high-yield savings or money market accounts that are separate from everyday spending money.',
        },
        {
          'question':
              'Which of the following is an appropriate use of an emergency fund?',
          'options': [
            'Buying holiday gifts',
            'Making a down payment on a car',
            'Paying for an unexpected major car repair',
            'Investing in a friend\'s business',
          ],
          'correctOptionIndex': 2,
          'explanation':
              'Emergency funds should be used for genuine emergencies like unexpected car repairs, medical bills, or job loss.',
        },
        {
          'question':
              'What should you do after using money from your emergency fund?',
          'options': [
            'Close the account',
            'Replenish it as soon as possible',
            'Transfer the remaining money to investments',
            'Wait until next year to add more money',
          ],
          'correctOptionIndex': 1,
          'explanation':
              'After using money from your emergency fund, you should make it a priority to replenish it as soon as your financial situation allows.',
        },
      ],
      'passingScore': 70,
      'timeLimit': 10,
    },
  ];

  static Future<void> uploadLessonsToFirebase() async {
    try {
      // Upload lessons
      for (var lesson in lessons) {
        DocumentReference docRef = await _firestore
            .collection('lessons')
            .add(lesson);
        String lessonId = docRef.id;

        // Update flashcards with the correct lessonId
        for (var flashcard in flashcards) {
          if (flashcard['lessonId'] == '${lesson['order']}') {
            flashcard['lessonId'] = lessonId;
          }
        }

        // Update quizzes with the correct lessonId
        for (var quiz in quizzes) {
          if (quiz['lessonId'] == '${lesson['order']}') {
            quiz['lessonId'] = lessonId;
          }
        }
      }

      // Upload flashcards
      for (var flashcard in flashcards) {
        await _firestore.collection('flashcards').add(flashcard);
      }

      // Upload quizzes
      for (var quiz in quizzes) {
        await _firestore.collection('quizzes').add(quiz);
      }

      print(
        'Successfully uploaded lessons, flashcards, and quizzes to Firebase!',
      );
    } catch (e) {
      print('Error uploading data to Firebase: $e');
    }
  }
}
