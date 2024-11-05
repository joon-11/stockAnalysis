import os
import json
import pykrx as krx
from crewai import Agent, Task, Crew
from crewai_tools import tool

os.environ["OPENAI_API_KEY"] = "sk-EnPss1rxDn9t2oCx87EgBCjxfagTQg0oy4eLnYVnMLT3BlbkFJrTDHXMdR-ISaTvzBDzGFTPZwfz41Pltvd5MHwaoO8A"
os.environ["OPENAI_MODEL_NAME"] = "gpt-4o-mini"

class StockAnalysisPipeline:
    def __init__(self, model_name="gpt-4o-mini"):
        os.environ["OPENAI_MODEL_NAME"] = model_name
        self._initialize_agents()
        self._initialize_tasks()
        self.crew = Crew(
            tasks=[self.research, self.technical_analysis, self.financial_analysis, self.investment_recommendation],
            agents=[self.researcher, self.technical_analyst, self.financial_analyst, self.hedge_fund_manager],
            verbose=True,
        )

    def _initialize_agents(self):
        """Initialize all agents for the pipeline."""
        self.researcher = Agent(
            role="연구원",
            goal="주식에 대한 감성과 뉴스를 종합적으로 파악하여 해석합니다.",
            backstory="다양한 소스에서 데이터를 수집하고 중요한 정보를 추출하는 데 능숙합니다.",
            verbose=True,
            output_file="_research_Agent.md",
            model="gpt-4o-mini",
        )

        self.technical_analyst = Agent(
            role="기술 분석가",
            goal="주식의 움직임을 분석하고 추세, 진입점, 저항선 및 지지선에 대한 통찰력을 제공합니다.",
            backstory="기술적 분석에 능숙한 전문가입니다.",
            verbose=True,
            output_file="_technical_analyst_Agent.md",
            model="gpt-4o-mini",
        )

        self.financial_analyst = Agent(
            role="금융 분석가",
            goal="재무 데이터 및 기타 지표를 사용하여 주식의 재무 건강을 평가합니다.",
            backstory="경험 많은 투자 자문가로서 재무 건강 및 시장 감성에 대한 권고를 제공합니다.",
            verbose=True,
            output_file="_financial_analyst_Agent.md",
            model="gpt-4o-mini",
            tools=[self.income_stmt, self.balance_sheet, self.insider_transactions],
        )

        self.hedge_fund_manager = Agent(
            role="헤지펀드 매니저",
            goal="금융 분석가와 연구원의 통찰력을 활용하여 주식 포트폴리오를 관리하고 투자 결정을 내립니다.",
            backstory="경험 많은 헤지펀드 매니저로서 고객에게 감동을 주는 투자 결정을 합니다.",
            verbose=True,
            output_file="_hedge_fund_manager_Agent.md",
            model="gpt-4o-mini",
        )

    def _initialize_tasks(self):
        """Initialize all tasks for the pipeline."""
        self.research = Task(
            description="{company}의 주식에 대한 뉴스와 시장 상황을 수집하고 분석합니다.",
            agent=self.researcher,
            expected_output="해당 주식에 대한 뉴스와 시장 감성 요약.",
            output_file="1_research_Task.md",
            model="gpt-4o-mini",
        )

        self.technical_analysis = Task(
            description="{company}의 주식 가격 움직임에 대한 기술적 분석을 수행합니다.",
            agent=self.technical_analyst,
            expected_output="잠재적 진입점, 가격 목표 등이 포함된 보고서.",
            output_file="2_technical_analysis_Task.md",
            model="gpt-4o-mini",
        )

        self.financial_analysis = Task(
            description="{company}의 재무제표 및 기타 지표를 분석하여 재무 건강을 평가합니다.",
            agent=self.financial_analyst,
            expected_output="재무 지표 개요를 포함한 보고서.",
            output_file="3_financial_analysis_Task.md",
            model="gpt-4o-mini",
        )

        self.investment_recommendation = Task(
            description="연구, 기술적 분석 및 재무 분석 보고서를 기반으로 투자 권고를 제공합니다.",
            agent=self.hedge_fund_manager,
            expected_output="매수, 매도 또는 보유에 대한 권고와 그 이유.",
            context=[self.research, self.technical_analysis, self.financial_analysis],
            output_file="4_investment_recommendation_Task.md",
            model="gpt-4o-mini",
        )

    @staticmethod
    @tool("Stock News")
    def stock_news(ticker):
        """Fetch news for a given stock ticker."""
        return f"현재 {ticker}에 대한 뉴스는 제공되지 않습니다."

    @staticmethod
    @tool("Stock Price")
    def stock_price(ticker):
        """Fetch the stock price data for the given ticker."""
        stock_data = krx.get_price(ticker)
        return stock_data.tail(30)

    @staticmethod
    @tool("Income Statement")
    def income_stmt(ticker):
        """Fetch the income statement for the given ticker."""
        stock_data = krx.get_financials(ticker)
        return stock_data['income_statement']

    @staticmethod
    @tool("Balance Sheet")
    def balance_sheet(ticker):
        """Fetch the balance sheet for the given ticker."""
        stock_data = krx.get_financials(ticker)
        return stock_data['balance_sheet']

    @staticmethod
    @tool("Insider Transactions")
    def insider_transactions(ticker):
        """Fetch insider transactions for the given ticker."""
        stock_data = krx.get_insider_transactions(ticker)
        return stock_data

    def analyze(self, company):
        result = self.crew.kickoff(inputs={"company": company})
        return result
    

stock = StockAnalysisPipeline()
result = stock.analyze("005930")


print(dir(result))  # 객체의 속성을 출력
