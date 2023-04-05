import json

# Open the JSON file
with open('results.json') as f:
    data = json.load(f)

# Extract the value of the email field
score = int(data['score'])

# Print the email value
print(score)