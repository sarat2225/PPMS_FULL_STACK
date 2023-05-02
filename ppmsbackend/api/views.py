from rest_framework.response import Response
from rest_framework.decorators import api_view

@api_view(['GET'])
def getData(request):
    team = {'name': 'Team 16','No.of members':4}
    return Response(team)