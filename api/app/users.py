from flask import Blueprint, jsonify, request

from .models import User, Note

users = Blueprint('users', __name__, url_prefix='/users')


@users.route('/<user_id>/notes', methods=['GET'])
def get_notes(user_id):
    return jsonify(Note.objects(user=user_id).all().to_json())
