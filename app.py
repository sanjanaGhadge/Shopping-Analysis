import streamlit as st
import pandas as pd
import plotly.express as px
import seaborn as sns
import matplotlib.pyplot as plt

# Load dataset
@st.cache_data
def load_data():
    return pd.read_csv('shopping_trends_updated.csv')

shop = load_data()

# Sidebar
st.sidebar.header("Shopping Trends Analysis")
analysis_option = st.sidebar.selectbox(
    "Choose an analysis",
    [
        "Age Distribution",
        "Average Purchase by Category",
        "Purchases by Gender",
        "Common Items by Category",
        "Seasonal Spending",
        "Average Ratings by Category",
        "Subscribed vs Non-Subscribed Purchases",
        "Popular Payment Methods",
        "Promo Code Spending",
        "Correlation: Size and Purchase Amount",
        "Shipping Type by Category",
        "Effect of Discounts",
        "Popular Colors",
        "Average Previous Purchases",
        "Purchase Behavior by Location",
        "Age and Product Categories",
        "Purchase Amount by Gender",
    ]
)

# Analysis Functions
if analysis_option == "Age Distribution":
    st.title("Age Distribution")
    shop['Age_category'] = pd.cut(shop['Age'], bins=[0, 15, 18, 30, 50, 70],
                                  labels=['Child', 'Teen', 'Young Adults', 'Middle-Aged Adults', 'Old'])
    fig = px.histogram(shop, x='Age_category', title="Distribution of Customer Ages")
    st.plotly_chart(fig)

elif analysis_option == "Average Purchase by Category":
    st.title("Average Purchase by Product Category")
    avg_purchase = shop.groupby('Category')['Purchase Amount (USD)'].mean()
    fig = px.bar(avg_purchase, x=avg_purchase.index, y=avg_purchase.values,
                 labels={'x': 'Category', 'y': 'Average Purchase (USD)'},
                 title="Average Purchase Amount Across Categories")
    st.plotly_chart(fig)

elif analysis_option == "Purchases by Gender":
    st.title("Purchases by Gender")
    gender_purchase = shop.groupby('Gender')['Purchase Amount (USD)'].sum()
    fig = px.bar(gender_purchase, x=gender_purchase.index, y=gender_purchase.values,
                 labels={'x': 'Gender', 'y': 'Total Purchase (USD)'},
                 title="Total Purchases by Gender")
    st.plotly_chart(fig)

# Common Items by Category
elif analysis_option == "Common Items by Category":
    st.title("Most Commonly Purchased Items by Category")
    common_items = shop.groupby('Category')['Item Purchased'].value_counts().reset_index(name='Count')
    fig = px.bar(common_items, x='Category', y='Count', color='Item Purchased',
                 title="Common Items by Category", barmode='stack')
    st.plotly_chart(fig)

# Seasonal Spending
elif analysis_option == "Seasonal Spending":
    st.title("Seasonal Spending")
    seasonal_spending = shop.groupby('Season')['Purchase Amount (USD)'].sum().reset_index()
    fig = px.bar(seasonal_spending, x='Season', y='Purchase Amount (USD)',
                 title="Customer Spending Across Seasons")
    st.plotly_chart(fig)

# Average Ratings by Category
elif analysis_option == "Average Ratings by Category":
    st.title("Average Ratings by Category")
    avg_ratings = shop.groupby('Category')['Review Rating'].mean().reset_index()
    fig = px.bar(avg_ratings, x='Category', y='Review Rating',
                 title="Average Ratings for Each Category")
    st.plotly_chart(fig)

# Subscribed vs Non-Subscribed Purchases
elif analysis_option == "Subscribed vs Non-Subscribed Purchases":
    st.title("Purchases by Subscription Status")
    sub_status = shop.groupby('Subscription Status')['Purchase Amount (USD)'].mean().reset_index()
    fig = px.bar(sub_status, x='Subscription Status', y='Purchase Amount (USD)',
                 title="Average Purchase Amount by Subscription Status")
    st.plotly_chart(fig)

# Popular Payment Methods
elif analysis_option == "Popular Payment Methods":
    st.title("Popular Payment Methods")
    payment_methods = shop['Payment Method'].value_counts().reset_index()
    payment_methods.columns = ['Payment Method', 'Count']
    fig = px.pie(payment_methods, names='Payment Method', values='Count',
                 title="Payment Method Popularity")
    st.plotly_chart(fig)

# Promo Code Spending
elif analysis_option == "Promo Code Spending":
    st.title("Promo Code Spending")
    promo_spending = shop.groupby('Promo Code Used')['Purchase Amount (USD)'].sum().reset_index()
    fig = px.bar(promo_spending, x='Promo Code Used', y='Purchase Amount (USD)',
                 title="Total Spending with and without Promo Codes")
    st.plotly_chart(fig)

# Correlation: Size and Purchase Amount
elif analysis_option == "Correlation: Size and Purchase Amount":
    st.title("Correlation Between Size and Purchase Amount")
    size_purchase = shop.groupby('Size')['Purchase Amount (USD)'].mean().reset_index()
    fig = px.scatter(size_purchase, x='Size', y='Purchase Amount (USD)',
                     title="Purchase Amount vs. Size")
    st.plotly_chart(fig)

# Shipping Type by Category
elif analysis_option == "Shipping Type by Category":
    st.title("Preferred Shipping Type by Category")
    shipping_category = shop.groupby(['Category', 'Shipping Type']).size().reset_index(name='Count')
    fig = px.bar(shipping_category, x='Category', y='Count', color='Shipping Type',
                 title="Preferred Shipping Types by Category")
    st.plotly_chart(fig)

# Effect of Discounts
elif analysis_option == "Effect of Discounts":
    st.title("Effect of Discounts on Purchases")
    discount_effect = shop.groupby('Discount Applied')['Purchase Amount (USD)'].sum().reset_index()
    fig = px.bar(discount_effect, x='Discount Applied', y='Purchase Amount (USD)',
                 title="Purchase Amount with and without Discounts")
    st.plotly_chart(fig)

# Popular Colors
elif analysis_option == "Popular Colors":
    st.title("Popular Colors")
    color_popularity = shop['Color'].value_counts().reset_index()
    color_popularity.columns = ['Color', 'Count']
    fig = px.bar(color_popularity, x='Color', y='Count', title="Most Popular Colors")
    st.plotly_chart(fig)

# Average Previous Purchases
elif analysis_option == "Average Previous Purchases":
    st.title("Average Number of Previous Purchases")
    avg_previous = shop['Previous Purchases'].mean()
    st.metric("Average Previous Purchases", f"{avg_previous:.2f}")

# Purchase Behavior by Location
elif analysis_option == "Purchase Behavior by Location":
    st.title("Purchase Behavior by Location")
    location_behavior = shop.groupby('Location')['Purchase Amount (USD)'].mean().reset_index()
    fig = px.bar(location_behavior, x='Location', y='Purchase Amount (USD)',
                 title="Average Purchase Amount by Location")
    st.plotly_chart(fig)

# Age and Product Categories
elif analysis_option == "Age and Product Categories":
    st.title("Relationship Between Age and Product Categories")
    age_category = shop.groupby('Category')['Age'].mean().reset_index()
    fig = px.bar(age_category, x='Category', y='Age',
                 title="Average Age of Customers by Product Category")
    st.plotly_chart(fig)

# Purchase Amount by Gender
elif analysis_option == "Purchase Amount by Gender":
    st.title("Purchase Amount by Gender")
    gender_purchase = shop.groupby('Gender')['Purchase Amount (USD)'].sum().reset_index()
    fig = px.bar(gender_purchase, x='Gender', y='Purchase Amount (USD)',
                 title="Total Purchase Amount by Gender")
    st.plotly_chart(fig)

# Footer
st.sidebar.text("© Shopping Trends Analysis Project")

